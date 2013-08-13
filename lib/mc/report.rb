module Report
  class BaseReport
    def initialize(api)
      @api = api
    end

    def run
      raise NotImplementedError.new("You must implement the run method.")
    end
  end

  class CampaignStats < BaseReport
    def initialize(api, start=0)
      super(api)
      @start = start
    end

    def run
      last_campaign_sent = @api.campaigns(:filters => {:status => "sent"}, :start => @start, :limit => 1)
      campaign_data = last_campaign_sent['data'].first
      campaign_id = campaign_data['id']

      campaign_stats = @api.campaign_stats({:cid => campaign_id})
      emails_sent = campaign_stats['emails_sent']

      email_domains = @api.campaign_email_domain_performance({:cid => campaign_id})

      puts "Details for #{campaign_data['title']} - #{campaign_data['archive_url']}"
      puts "==="
      puts "Sent at #{campaign_data['send_time']}"
      puts "Last open at #{campaign_stats['last_open']}"

      puts "--"
      puts "Emails sent: #{emails_sent}"
      puts "Opens: #{campaign_stats['unique_opens']} (%#{(campaign_stats['unique_opens'].to_f / emails_sent).round(4) * 100})"
      puts "Users who clicked: #{campaign_stats['users_who_clicked']} (%#{(campaign_stats['users_who_clicked'].to_f / emails_sent).round(4) * 100})"
      puts "Clicks: #{campaign_stats['unique_clicks']}"

      puts "--"
      puts "Unsubscribers: #{campaign_stats['unsubscribes']}"
      puts "Hard/Soft Bounces: #{campaign_stats['hard_bounces']}/#{campaign_stats['soft_bounces']}"
      puts "Abuse reports: #{campaign_stats['abuse_reports']}"

      puts "--"
      email_domains.each do |domain|
        puts "#{domain['emails']} sent to #{domain['domain']} - open/click count: #{domain['opens']}/#{domain['clicks']} - open/click %: #{domain['opens_pct']}/#{domain['clicks_pct']}"
      end

      puts "--"
      most_clicked_links(campaign_id).first(20).each do |url,clicks|
        puts "#{clicks} - #{url[0..70]}"
      end
    end

    def most_clicked_links(campaign_id)
      most_clicked = {}

      url_click_stats = @api.campaign_click_stats({:cid => campaign_id})
      url_click_stats.each do |stat|
        most_clicked[stat.first] = stat.last['unique']
      end

      most_clicked.sort_by {|url,clicks| -clicks}
    end
  end

  class TotalClicks < BaseReport
    def initialize(api, list_id)
      super(api)
      @list_id = list_id
    end

    def run
      @api.campaigns(:filters => {:list_id => @list_id}, :limit => 25)['data'].each do |campaign|
        puts "#{campaign['subject']} - #{@api.campaignStats({:cid => campaign['id']})['clicks'].to_i}"
      end
    end
  end
 
  class ArchiveUrls < BaseReport
    def initialize(api, list_id)
      super(api)
      @list_id = list_id
    end

    def run
      @api.campaigns(:filters => {:list_id => @list_id}, :limit => 20)['data'].each do |campaign|
        if campaign['subject'] != nil 
          puts "<a href=\"#{campaign['archive_url']}\" class=\"link\">#{campaign['subject'].match('\d+')}</a>,"
        end
      end
    end
  end

  class Zeitgest < BaseReport
    def initialize(api, list_id, year)
      super(api)
      @list_id = list_id
      @year    = year
    end

    def run
      @campaigns = load_campaigns
      yearly_most_popular
    end

    def load_campaigns
      campaigns = []

      @api.campaigns_list(:filters => {:list_id => @list_id}, :limit => 100)['data'].each do |campaign|
        if campaign['send_time'] != nil && campaign['send_time'].match(/#{@year.to_s}/)
          campaigns << campaign
        end
      end

      return campaigns
    end

    def yearly_most_popular
      stats = {}
      max_rate = 0

      @campaigns.each do |campaign|
        @api.campaignClickStats(:cid => campaign['id']).each do |item|
          url, stat = item
          click_rate = (stat["clicks"] / campaign['emails_sent'].to_f) * 100
          max_rate = click_rate if click_rate > max_rate
          stats[url] = [click_rate, campaign['send_time'][5..6]]
        end
      end

      normalize = 100 / max_rate

      stats.sort_by { |url, clicks| clicks[0] }.reverse[0..100].each_with_index do |(url, data), index|
        click_rate, month = data
        puts "#{index}. #{url} - #{click_rate * normalize} in #{month}"
      end
    end
  end
end

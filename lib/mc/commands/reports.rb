desc 'Reports'
command :reports do |c|
  # reports/abuse (string apikey, string cid, struct opts)
  c.desc 'Get all email addresses that complained about a given campaign'
  c.command :abuse do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      member_column = lambda{|l| "#{l['member']['email']}"}
      @output.standard @mailchimp_cached.reports_abuse(:cid => cid)['data'], :fields => [:member => {:display_method => member_column}]
    end
  end

  # reports/advice (string apikey, string cid)
  c.desc 'Retrieve the text presented in our app for how a campaign performed and any advice we may have for you'
  c.command :advice do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.as_hash @mailchimp_cached.reports_advice :cid => cid
    end
  end

  # reports/bounce-message (string apikey, string cid, struct email)
  c.desc 'Retrieve the most recent full bounce message for a specific email address on the given campaign. Messages over 30 days old are subject to being removed'
  c.command :bounce do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      email = create_email_struct(required_argument("Need to provide an email address.", args))
      puts @mailchimp_cached.reports_bounce_message(:cid => cid, :email => email.first)['message']
    end
  end

  # reports/bounce-messages (string apikey, string cid, struct opts)
  c.desc 'Retrieve the full bounce messages for the given campaign. Messages over 30 days old are subject to being removed'
  c.command :bounces do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id

      results = @mailchimp_cached.reports_bounce_messages(:cid => cid)
      if global[:output]
        @output.standard results
      else
        if results['total'].to_i > 0
          puts "BOUNCE MSGS FOR LAST/SELECTED CAMPAIGN (#{results['total']})"
          results['data'].each do |bounce|
            puts "#{'='*50}".red
            puts "Subscriber: #{bounce['member']['email']}"
            puts "Date: #{bounce['date']}\n\n"
            puts bounce['message'].green
            puts "\n"
          end
        else
          puts "No bounce messages for the last/selected campaign."
        end
      end
    end
  end

  # reports/click-detail (string apikey, string cid, int tid, struct opts)
  c.desc 'Return the list of email addresses that clicked on a given url, and how many times they clicked'
  c.command 'clicked-url' do |s|
    s.arg_name 'campaign id'
    s.flag :cid
    s.flag :tid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      tid = options[:tid]
      member_column = lambda{|l| "#{l['member']['email']}"}
      @output.standard @mailchimp_cached.reports_click_detail(:cid => cid, :tid => tid)['data'], :fields => [:clicks, {:member => {:display_method => member_column}}]
    end
  end

  # reports/clicks (string apikey, string cid)
  c.desc 'The urls tracked and their click counts for a given campaign.'
  c.command :clicks do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_clicks(:cid => cid)['total'], :fields => [:tid, {:url => {:width => 80}}, :clicks, :unique]
    end
  end

  # reports/domain-performance (string apikey, string cid)
  c.desc 'Get the top 5 performing email domains for this campaign.'
  c.command :domains do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_domain_performance :cid => cid
    end
  end

  # reports/ecomm-orders (string apikey, string cid, struct opts)
  c.desc 'Retrieve the Ecommerce Orders tracked by campaignEcommOrderAdd()'
  c.command :ecomm do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_ecomm_orders(:cid => cid)['data']
    end
  end

  # reports/eepurl (string apikey, string cid)
  c.desc 'Retrieve the eepurl stats from the web/Twitter mentions for this campaign'
  c.command :eepurl do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.as_hash @mailchimp_cached.reports_eepurl(:cid => cid)
    end
  end

  # reports/geo-opens (string apikey, string cid)
  c.desc 'Retrieve the countries/regions and number of opens tracked for each. Email address are not returned.'
  c.command :geo do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_geo_opens(:cid => cid), :fields => [:code, :name, :opens]
    end
  end

  # reports/google-analytics (string apikey, string cid)
  c.desc 'Retrieve the Google Analytics data we have collected for this campaign.'
  c.command :ga do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_google_analytics :cid => cid
    end
  end

  # reports/member-activity (string apikey, string cid, array emails)
  c.desc 'Given a campaign and email address, return the entire click and open history with timestamps, ordered by time.'
  c.command 'member-activity' do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      email = create_email_struct(required_argument("Need to provide an email address.", args))
      results = @mailchimp_cached.reports_member_activity(:cid => cid, :emails => email)['data']

      results.each do |result|
        puts result['email']['email']
        puts "#{'='*result['email']['email'].size}"
        @output.as_table result['activity']
        puts "\n"
      end
    end
  end

  # reports/not-opened (string apikey, string cid, struct opts)
  c.desc 'Retrieve the list of email addresses that did not open a given campaign'
  c.command 'not-opened' do |s|
    s.arg_name 'campaign id'
    s.flag :cid
    s.flag :start, :default_value => 0
    s.flag :limit, :default_value => 50

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      opts = {:start => options['start'], :limit => options['limit']}
      @output.standard @mailchimp_cached.reports_not_opened(:cid => cid, :opts => opts)['data'], :fields => [:email]
    end
  end

  # reports/opened (string apikey, string cid, struct opts)
  c.desc 'Retrieve the list of email addresses that opened a given campaign with how many times they opened'
  c.command :opened do |s|
    s.arg_name 'campaign id'
    s.flag :cid
    s.flag :start, :default_value => 0
    s.flag :limit, :default_value => 50
    s.flag 'sort-field', :default_value => "opened"
    s.flag 'sort-dir', :default_value => "asc"

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      opts = {:start => options['start'], :limit => options['limit'], :sort_field => options['sort-field'], :sort_dir => options['sort-dir']}
      member_column = lambda{|l| "#{l['member']['email']}"}

      @output.standard @mailchimp_cached.reports_opened(:cid => cid, :opts => opts)['data'], :fields => [:opens, {:member => {:display_method => member_column}}]
    end
  end

  # reports/sent-to (string apikey, string cid, struct opts)
  c.desc 'Get email addresses the campaign was sent to'
  c.command 'sent-to' do |s|
    s.arg_name 'campaign id'
    s.flag :cid
    s.flag :status
    s.flag :start, :default_value => 0
    s.flag :limit, :default_value => 50

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      opts = {:status => options['status'], :start => options['start'], :limit => options['limit']}
      member_column = lambda{|l| "#{l['member']['email']}"}
      @output.standard @mailchimp_cached.reports_sent_to(:cid => cid, :opts => opts)['data'], :fields => [:member => {:display_method => member_column}]
    end
  end

  # reports/share (string apikey, string cid, array opts)
  c.desc 'Get the URL to a customized VIP Report for the specified campaign and optionally send an email to someone with links to it.'
  c.command :share do |s|
    s.arg_name 'campaign id'
    s.flag :cid

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id

      results = @mailchimp_cached.reports_share(:cid => cid)
      if global[:output]
        @output.standard results
      else
        puts results['title']
        puts "#{'='*results['title'].size}"
        puts "URL: #{results['url']}"
        puts "PASSWORD: #{results['password']}"
        puts "SECURE URL: #{results['secure_url']}"
      end
    end
  end

  # reports/summary (string apikey, string cid)
  c.desc 'Retrieve relevant aggregate campaign statistics (opens, bounces, clicks, etc.)'
  c.command :summary do |s|
    s.desc 'Campaign ID'
    s.flag :cid

    s.action do |global,options,args|
      ap options
      cid = options[:cid] || get_last_campaign_id
      @output.as_hash @mailchimp_cached.reports_summary(:cid => cid)
    end
  end

  # reports/unsubscribes (string apikey, string cid, struct opts)
  c.desc 'Get all unsubscribed email addresses for a given campaign'
  c.command :unsubscribes do |s|
    s.arg_name 'campaign id'
    s.flag :cid
    s.flag :start, :default_value => 0
    s.flag :limit, :default_value => 50

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      opts = {:start => options['start'], :limit => options['limit']}
      @output.standard @mailchimp_cached.reports_unsubscribes(:cid => cid, :opts => opts)['data'], :fields => [:email]
    end
  end
end

desc 'Reports'
command :reports do |c|

  # reports/abuse (string apikey, string cid, struct opts)
  c.desc 'Get all email addresses that complained about a given campaign'
  c.command :abuse do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/advice (string apikey, string cid)
  c.desc 'Retrieve the text presented in our app for how a campaign performed and any advice we may have for you'
  c.command :advice do |s|
    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      #cid = @mailchimp.campaigns_list(:limit => 1, :sort_field => "send_time")["data"].first["id"]
      @output.as_hash @mailchimp_cached.reports_advice :cid => cid
    end
  end

  # reports/bounce-message (string apikey, string cid, struct email)
  c.desc 'Retrieve the most recent full bounce message for a specific email address on the given campaign. Messages over 30 days old are subject to being removed'
  c.command :bounce do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/bounce-messages (string apikey, string cid, struct opts)
  c.desc 'Retrieve the full bounce messages for the given campaign. Note that this can return very large amounts of data depending on how large the campaign was and how much cruft the bounce provider returned. Also, messages over 30 days old are subject to being removed'
  c.command :bounces do |s|
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
  c.command :clicked do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/clicks (string apikey, string cid)
  c.desc 'The urls tracked and their click counts for a given campaign.'
  c.command :clicks do |s|
    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_clicks(:cid => cid)['total'], :fields => [{:url => {:width => 80}}, :clicks, :unique]
    end
  end

  # reports/domain-performance (string apikey, string cid)
  c.desc 'Get the top 5 performing email domains for this campaign.'
  c.command :domains do |s|
    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_domain_performance :cid => cid
    end
  end

  # reports/ecomm-orders (string apikey, string cid, struct opts)
  c.desc 'Retrieve the Ecommerce Orders tracked by campaignEcommOrderAdd()'
  c.command :ecomm do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/eepurl (string apikey, string cid)
  c.desc 'Retrieve the eepurl stats from the web/Twitter mentions for this campaign'
  c.command :eepurl do |s|
    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_eepurl :cid => cid
    end
  end

  # reports/geo-opens (string apikey, string cid)
  c.desc 'Retrieve the countries/regions and number of opens tracked for each. Email address are not returned.'
  c.command :geo do |s|
    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_geo_opens :cid => cid
    end
  end

  # reports/google-analytics (string apikey, string cid)
  c.desc 'Retrieve the Google Analytics data we have collected for this campaign.'
  c.command :ga do |s|
    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id
      @output.standard @mailchimp_cached.reports_google_analytics :cid => cid
    end
  end

  # reports/member-activity (string apikey, string cid, array emails)
  c.desc 'Given a campaign and email address, return the entire click and open history with timestamps, ordered by time.'
  c.command :member_activity do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/not-opened (string apikey, string cid, struct opts)
  c.desc 'Retrieve the list of email addresses that did not open a given campaign'
  c.command :not_opened do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/opened (string apikey, string cid, struct opts)
  c.desc 'Retrieve the list of email addresses that opened a given campaign with how many times they opened'
  c.command :opened do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/sent-to (string apikey, string cid, struct opts)
  c.desc 'Get email addresses the campaign was sent to'
  c.command :sent_to do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/share (string apikey, string cid, array opts)
  c.desc 'Get the URL to a customized VIP Report for the specified campaign and optionally send an email to someone with links to it.'
  c.command :share do |s|
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
    s.action do |global,options,args|
      not_implemented
    end
  end

  # reports/unsubscribes (string apikey, string cid, struct opts)
  c.desc 'Get all unsubscribed email addresses for a given campaign'
  c.command :unsubscribes do |s|
    s.action do |global,options,args|
      not_implemented
    end
  end
end

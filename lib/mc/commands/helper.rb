desc 'Basic admin funtions'
command :helper do |c|
  c.desc 'View API key currently configured'
  c.command :apikey do |apikey|
    apikey.action do |global,options,args|
      puts global[:apikey]
    end
  end

  c.desc 'Show cache'
  c.command :cache do |cache|
    cache.action do |global,options,args|
      puts "Campaign id in cache: #{@mailchimp.cache.get(:campaign_id)}"
    end
  end

  # === Actual MailChimp API Calls below ===

  # helper/account-details (string apikey, array exclude)
  c.desc 'Retrieve lots of account information'
  c.command :account do |s|
    s.action do |global,options,args|
      cli_print @mailchimp_cached.helper_account_details, :all, :debug => true, :show_header => false
    end
  end

  # helper/campaigns-for-email (string apikey, struct email, struct options)
  c.desc 'Retrieve minimal data for all Campaigns a member was sent'
  c.command :campaigns_for_email do |s|
    s.action do |global,options,args|
      puts @mailchimp_cached.helper_camaigns_for_email options[:email]
    end
  end
  
  # helper/chimp-chatter (string apikey)
  c.desc 'See the current Chimp Chatter messages.'
  c.command :chatter do |s|
    s.action do |global,options,args|
      cli_print @mailchimp.helper_chimp_chatter, :message
    end
  end    

  # helper/lists-for-email (string apikey, struct email)
  c.desc 'Retrieve minimal List data for all lists a member is subscribed to.'
  c.command :lists_for_email do |s|
    s.action do |global,options,args|
      cli_print @mailchimp_cached.helper_account_details, :all, :debug => true, :show_header => false
    end
  end

  c.desc 'Ping MailChimp to make sure all is okay.'
  c.command :ping do |s|
    s.action do |global,options,args|
      puts @mailchimp.ping
    end
  end

  # helper/verified-domains (string apikey)
  c.desc 'Retrieve all domain verification records for an account'
  c.command :verified do |s|
    s.action do |global,options,args|
      puts @mailchimp_cached.helper_verified_domains
    end
  end
end

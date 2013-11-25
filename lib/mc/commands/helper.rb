desc 'Basic admin funtions'
command :helper do |c|
  c.desc 'View API key currently configured'
  c.command :apikey do |s|
    s.action do |global,options,args|
      puts global[:apikey]
    end
  end

  c.desc 'View user_id of account'
  c.command :userid do |s|
    s.action do |global,options,args|
      puts @mailchimp_cached.helper_account_details['user_id']
    end
  end

  c.desc 'View default list if set in config file'
  c.command 'default-list' do |s|
    s.action do |global,options,args|
      global[:list].nil? ? puts('No default list set.') : puts(global[:list])
    end
  end

  c.desc 'Quickly see the last campaign sent'
  c.command 'last-campaign' do |s|
    s.action do |global,options,args|
      result = @mailchimp.campaigns_list(:limit => 1)['data'].first
      puts "#{result['id']}: #{result['title']}"
    end
  end

  # === Actual MailChimp API Calls below ===

  # helper/account-details (string apikey, array exclude)
  c.desc 'Retrieve lots of account information'
  c.command :account do |s|
    s.action do |global,options,args|
      @output.as_hash @mailchimp_cached.helper_account_details
    end
  end

  # helper/campaigns-for-email (string apikey, struct email, struct options)
  c.desc 'Retrieve minimal data for all Campaigns a member was sent'
  c.command 'campaigns-for-email' do |s|
    s.action do |global,options,args|
      emails = create_email_struct(required_argument("Need to provide an email address.", args))
      @output.standard @mailchimp_cached.helper_campaigns_for_email(:email => emails.first), :fields => [:id, {:title => {:width => 50}}, :send_time]
    end
  end

  # helper/chimp-chatter (string apikey)
  c.desc 'See the current Chimp Chatter messages.'
  c.command :chatter do |s|
    s.action do |global,options,args|
      # get rid of all the crap in the chatter msgs so they are useful
      message = lambda{|m| m['message'].gsub(/ - Nice!.*few/, '').gsub(/ - Bummer.*:/, ':').gsub(/ - People.*:/, ':').gsub(/"/, '')}

      @output.standard @mailchimp_cached.helper_chimp_chatter.reverse, :fields => [:update_time, {:message => {:width => 100, :display_method => message}}]
    end
  end

  # helper/lists-for-email (string apikey, struct email)
  c.desc 'Retrieve minimal List data for all lists a member is subscribed to.'
  c.command 'lists-for-email' do |s|
    s.action do |global,options,args|
      emails = create_email_struct(required_argument("Need to provide an email address.", args))
      @output.standard @mailchimp_cached.helper_lists_for_email :email => emails.first
    end
  end

  c.desc 'Ping MailChimp to make sure all is okay.'
  c.command :ping do |s|
    s.action do |global,options,args|
      puts @mailchimp.helper_ping['msg']
    end
  end

  # helper/verified-domains (string apikey)
  c.desc 'Retrieve all domain verification records for an account'
  c.command :verified do |s|
    s.action do |global,options,args|
      @output.standard @mailchimp_cached.helper_verified_domains
    end
  end
end

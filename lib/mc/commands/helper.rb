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

  c.desc 'Ping MailChimp to make sure all is okay.'
  c.command :ping do |s|
    s.action do |global,options,args|
      puts @mailchimp.ping
    end
  end

  c.desc 'See the current Chimp Chatter messages.'
  c.command :chatter do |s|
    s.action do |global,options,args|
      cli_print @mailchimp.chimp_chatter, :message
    end
  end    
end
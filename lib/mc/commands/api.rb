desc 'API/Security related commands'
command :api do |c|

  c.desc 'MailChimp username'
  c.flag [:username]

  c.desc 'MailChimp password'
  c.flag [:password]

  c.desc 'Add an API Key to your account.'
  c.command :add do |s|
    s.action do |global,options,args|
      # apikeyAdd(string username, string password, string apikey)
      @mailchimp.apikey_add(:username => options[:username], :password => options[:password])
    end
  end

  c.desc 'Expire a Specific API Key.'
  c.command :expire do |s|
    c.flag :apikey_to_expire
    s.action do |global,options,args|
      # apikeyExpire(string username, string password, string apikey)
      @mailchimp.apikey_expire(:username => options[:username], :password => options[:password], :apikey => options[:apikey_to_expire])
    end
  end

  c.desc 'List of all MailChimp API Keys.'
  c.command :list do |s|
    s.action do |global,options,args|
      # apikeys(string username, string password, string apikey, boolean expired)
      cli_print @mailchimp.apikeys(:username => options[:username], :password => options[:password]), :all      
    end
  end
end
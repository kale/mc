desc 'Users'
command :users do |c|
  # users/invite (string apikey, string email, string role, string msg)
  c.desc 'Invite a user to your account'
  c.command :invite do |s|
    s.action do |global,options,args|
      emails = create_email_struct(options[:email])

      status = @mailchimp.vip_add(:id => id, :emails => emails)
      puts status
    end
  end

  # useres/logins (string apikey)
  c.desc 'Retrieve the list of active logins.'
  c.command :logins do |s|
    s.action do
      puts @mailchimp_cached.users_logins
    end
  end
end

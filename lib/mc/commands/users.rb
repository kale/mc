desc 'Users'
command :users do |c|
  # users/invite (string apikey, string email, string role, string msg)
  c.desc 'Invite a user to your account'
  c.command :invite do |s|
    s.flag :role
    s.flag :msg

    s.action do |global,options,args|
      email = required_argument("Need to provide an email address.", args)
      role  = options[:role]
      msg   = options[:msg]

      @output.standard @mailchimp.users_invites(:email => email, :role => role, :msg => msg)
    end
  end

  # users/invite-resend (string apikey, string email)
  c.desc 'Resend an invite a user to your account.'
  c.command 'invite-revoke' do |s|
    s.action do |global,options,args|
      email = required_argument("Need to provide email address.", args)
      @output.standard @mailchimp.users_login_revoke(:email => email)
    end
  end

  # users/invite-revoke (string apikey, string email)
  c.desc 'Revoke an invitation sent to a user to your account.'
  c.command 'invite-revoke' do |s|
    s.action do |global,options,args|
      email = required_argument("Need to provide email address.", args)
      @output.standard @mailchimp.users_login_revoke(:email => email)
    end
  end

  # users/invites (string apikey)
  c.desc 'Retrieve the list of pending users invitations have been sent for.'
  c.command :invites do |s|
    s.action do
      @output.standard @mailchimp_cached.users_invites
    end
  end

  # users/login-revoke (string apikey, string username)
  c.desc 'Revoke access for a specified login.'
  c.command 'login-revoke' do |s|
    s.action do |global,options,args|
      username = required_argument("Need to provide login username.", args)
      @output.standard @mailchimp.users_login_revoke(:username => username)
    end
  end

  # users/logins (string apikey)
  c.desc 'Retrieve the list of active logins.'
  c.command :logins do |s|
    s.action do |global,options,args|
      @output.standard @mailchimp_cached.users_logins
    end
  end

  # users/profile (string apikey)
  c.desc 'Retrieve the profile for the login owning the provided API Key.'
  c.command :profile do |s|
    s.action do |global,options,args|
      @output.standard @mailchimp_cached.users_profile
    end
  end
end

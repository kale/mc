desc 'VIPs'
command :vip do |c|

  c.desc 'Email Address to add/remove'
  c.flag :email

  c.desc 'List ID'
  c.flag :id

  # vip/activity (string apikey)
  c.desc 'Show all Activity (opens/clicks) for VIPs over the past 10 days'
  c.command :activity do |s|
    s.action do
      cli_print @mailchimp.vip_activity, [:email, :action, :title, :timestamp], :reverse => true
    end
  end

  # vip/add (string apikey, string id, array emails)
  c.desc 'Add VIP(s)'
  c.command :add do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      emails = create_email_struct(options[:email])

      status = @mailchimp.vip_add(:id => id, :emails => emails)
      puts status
    end
  end

  # vip/del (string apikey, string id, array emails)
  c.desc 'Remove VIP(s)'
  c.command :remove do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      emails = create_email_struct(options[:email])
      
      status = @mailchimp.vip_del(:id => id, :emails => emails)
      #TODO: create helper method to display success
      puts status
      #status["success"] > 0 ? "#{options[:email]} removed!" : "Oops!"
    end
  end
  
  # vip/members (string apikey)
  c.desc 'List all VIPs'
  c.command :members do |s|
    s.action do
      cli_print @mailchimp.vip_members, [:index, :email, :list_name, :list_id]
    end
  end
end

desc 'VIPs'
command :vip do |c|
  c.desc 'List ID'
  c.flag :id

  # vip/activity (string apikey)
  c.desc 'Show all Activity (opens/clicks) for VIPs over the past 10 days'
  c.command :activity do |s|
    s.action do
      @output.standard @mailchimp_cached.vip_activity, :fields => [:email, :action, :title, :timestamp, :url], :reverse => true
    end
  end

  # vip/add (string apikey, string id, array emails)
  c.desc 'Add VIP(s)'
  c.command :add do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      emails = create_email_struct(required_argument("Need to provide an email address.", args))

      status = @mailchimp.vip_add(:id => id, :emails => emails)
      if emails.count == status['success_count']
        puts "Successfully added email(s)!"
      else
        @output.errors status
      end
    end
  end

  # vip/del (string apikey, string id, array emails)
  c.desc 'Remove VIP(s)'
  c.command :remove do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      emails = create_email_struct(required_argument("Need to provide an email address.", args))

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
      @output.standard @mailchimp_cached.vip_members, :fields => [:email, :list_name, :member_rating]
    end
  end
end

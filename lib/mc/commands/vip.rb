desc 'VIPs'
command :vip do |c|
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
    s.desc 'List ID'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      emails = create_email_struct(required_argument("Need to provide an email address.", args))

      status = @mailchimp.vip_add(:id => id, :emails => emails)

      puts "Added #{status['success_count']} subscriber(s) as VIPs." if successful? status
      show_errors status
    end
  end

  # vip/del (string apikey, string id, array emails)
  c.desc 'Remove VIP(s)'
  c.command :remove do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      emails = create_email_struct(required_argument("Need to provide an email address.", args))

      status = @mailchimp.vip_del(:id => id, :emails => emails)

      puts "Removed #{status['success_count']} subscriber(s) as VIPs." if successful? status
      show_errors status
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

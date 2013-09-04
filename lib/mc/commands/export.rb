desc 'Export'
command :export do |c|
  # list ( string apikey, string id, string status array segment, string since )
  c.desc 'Exports/dumps members of a list and all of their associated details.'
  c.command :list do |s|
    c.desc 'List ID'
    c.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      @output.standard @mailchimp_cached.export_list(id)
    end
  end
  
  # ecommOrders ( string since )
  c.desc 'Dumps all Ecommerce Orders for an account'
  c.command :ecommm do |s|
    c.flag :since

    s.action do |global,options,args|
      @output.standard @mailchimp_cached.export_ecomm_orders
    end
  end

  # campaignSubscriberActivity ( string apikey, string id, boolean include_empty, string since )
  c.command :campaign do |s|
    s.action do |global,options,args|
      c.desc 'Campaign ID'
      c.flag :cid
      c.switch :include_empty

      id = get_required_argument(:id, options[:id], global[:default_list])
      @output.standard @mailchimp_cached.export_campaign_subscriber_activity
    end
  end
end


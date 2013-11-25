desc 'Export'
command :export do |c|
  # list ( string apikey, string id, string status array segment, string since )
  c.desc 'Exports/dumps members of a list and all of their associated details.'
  c.command :list do |s|
    c.desc 'List ID'
    c.flag :id

    c.flag :status

    c.desc "Use either 'any' or 'all'"
    c.flag :match, :default_value => 'all'

    c.desc 'Condition in the format field,op,value'
    c.flag :condition

    s.action do |global,options,args|
      id = required_option(:id, options[:id], global[:list])

      if options[:condition]
        segment = {}
        segment['match'] = options[:match]
        field, op, value = options[:condition].split(',')
        segment['conditions'] = [{:field => field, :op => op, :value => value}]
      end

      status = options[:status]

      @mailchimp.export_list(:id => id, :status => status, :segment => segment).each do |subscriber|
        puts subscriber
      end
    end
  end

  # ecommOrders ( string since )
  c.desc 'Dumps all Ecommerce Orders for an account'
  c.command :ecommm do |s|
    c.desc 'Ecomm orders since a specific date'
    c.flag :since

    s.action do |global,options,args|
      @mailchimp.export_ecomm_orders.each do |order|
        puts order
      end
    end
  end

  # campaignSubscriberActivity ( string apikey, string id, boolean include_empty, string since )
  c.command :activity do |s|
    c.desc 'Campaign ID'
    c.flag :cid

    c.desc 'Export all subscribers even if they have no activity'
    c.switch :include_empty, :negatable => false

    s.action do |global,options,args|
      cid = options[:cid] || get_last_campaign_id

      @mailchimp.export_campaign_subscriber_activity(:id => cid).each do |activity|
        puts activity
      end
    end
  end
end

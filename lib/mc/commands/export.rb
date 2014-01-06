desc 'Export list, ecomm, or activity streams (no caching)'
long_desc 'Uses the Export API and will stream results. These commands do not do any caching, and thus you should be careful about running these multiple times. A typical way to use this command would be to redirect output to a file. Example: mc export activity --cid 1234567 > campaign_activity.txt'
command :export do |c|
  # list ( string apikey, string id, string status array segment, string since )
  c.desc 'Exports/dumps members of a list and all of their associated details.'
  c.command :list do |s|
    s.flag :status

    s.desc "Use either 'any' or 'all'"
    s.flag :match, :default_value => 'all'

    s.desc 'Condition in the format field,op,value'
    s.flag :condition

    s.action do |global,options,args|
      id = required_argument(:id, args.first, global[:list])

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
    s.desc 'Ecomm orders since a specific date'
    s.flag :since

    s.action do |global,options,args|
      @mailchimp.export_ecomm_orders.each do |order|
        puts order
      end
    end
  end

  # campaignSubscriberActivity ( string apikey, string id, boolean include_empty, string since )
  c.desc 'Dumps all Subscriber Activity for the requested campaign'
  c.command :activity do |s|
    s.desc 'Export all subscribers even if they have no activity'
    s.switch :include_empty, :negatable => false

    s.desc 'Use last created campaign id'
    s.switch [:lcid, 'use-last-campaign-id'], :negatable => false

    s.action do |global,options,args|
      cid = required_argument("Missing or invalid campaign id", args.first, get_last_campaign_id(options[:lcid]))

      @mailchimp.export_campaign_subscriber_activity(:id => cid).each do |activity|
        puts activity
      end
    end
  end
end

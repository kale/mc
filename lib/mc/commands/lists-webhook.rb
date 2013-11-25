command :lists do |lists|
  lists.desc 'Manage webhooks for a given lists'
  lists.command :webhook do |c|
    #lists/webhook-add (string apikey, string id, string url, struct actions, struct sources)
    c.desc 'Add a new Webhook URL for the given list'
    c.command :add do |s|
      s.desc 'list id'
      s.flag :id

      s.action do |global,options,args|
        s.flag :url
        id = required_argument(:id, options[:id], global[:list])
        @output.standard @mailchimp.lists_webhook_add(:id => id, :url => options[:url])
      end
    end

    #lists/webhook-del (string apikey, string id, string url)
    c.desc 'Delete an existing Webhook URL from a given list'
    c.command :delete do |s|
      s.desc 'list id'
      s.flag :id

      s.action do |global,options,args|
        s.flag :url
        id = required_argument(:id, options[:id], global[:list])
        @output.standard @mailchimp.lists_webhook_del(:id => id, :url => options[:url])
      end
    end

    #lists/webhooks (string apikey, string id)
    c.desc 'Return the Webhooks configured for the given list'
    c.command :list do |s|
      s.desc 'list id'
      s.flag :id

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        @output.standard @mailchimp_cached.lists_webhooks(:id => id)
      end
    end

    c.default_command :list
  end
end

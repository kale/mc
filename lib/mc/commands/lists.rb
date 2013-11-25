desc 'View information about lists and subscribers'
command :lists do |c|
  c.desc 'Get all email addresses that complained about a campaign sent to a list'
  c.command 'abuse-reports' do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_activity(:id => id)
    end
  end

  # c.desc 'Subscribe a batch of email addresses to a list at once.'
  # c.command 'batch-subscribe' do |s|
  #   s.action do |global,options,args|
  #   end
  # end

  # c.desc 'Unsubscribe a batch of email addresses from a list.'
  # c.command 'batch-unsubscribe' do |s|
  #   s.action do |global,options,args|
  #   end
  # end

  c.desc "Retrieve the clients that the list's subscribers have been tagged as being used based on user agents seen."
  c.command :clients do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])

      results = @mailchimp_cached.lists_clients(:id => id)
      if global[:output]
        @output.as_hash results
      else
        percent = lambda{|i| i['percent'].round(2)}
        puts "#{'='*14} DESKTOP #{'='*14}"
        @output.standard results['desktop']['clients'], :fields => [:members, :client, {:percent => {:display_method => percent}}]
        puts "\n#{'='*14} MOBILE #{'='*14}"
        @output.standard results['mobile']['clients'], :fields => [:members, :client, {:percent => {:display_method => percent}}]
      end
    end
  end

  c.desc 'Access the Growth History by Month for a given list.'
  c.command :growth do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_growth_history(:id => id)
    end
  end

  c.desc 'Retrieve all of the lists defined for your user account.'
  c.command :list do |s|
    s.action do |global,options,args|
      stats_column = lambda{|l| "#{l['stats']['member_count']} / #{na(l['stats']['open_rate'])} / #{na(l['stats']['click_rate'])}"}
      @output.standard @mailchimp_cached.lists_list['data'], :fields => [:id, :name, {"count / open % / click %" => stats_column}]
    end
  end

  c.desc 'Retrieve the locations (countries) that the list\'s subscribers have been tagged to based on geocoding their IP address.'
  c.command :locations do |s|
    s.desc 'list id'
    s.flag :id
    s.flag :num, :default_value => 25

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_locations(:id => id)[0..options[:num].to_i]
    end
  end

  c.desc 'Get the most recent 100 activities for particular list members.'
  c.arg_name 'emails'
  c.command 'member-activity' do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      emails = create_email_struct(required_argument("Need to provide one or more email addresses.", args))

      @output.standard @mailchimp_cached.lists_member_activity(:id => id, :emails => emails)['data'].first['activity'], :fields => [:action, :timestamp, :title, :url]
    end
  end

  c.desc 'Get information about one particular member.'
  c.arg_name 'emails'
  c.command 'member-info' do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      emails = create_email_struct(required_argument("Need to provide one or more email addresses.", args))

      @output.as_hash @mailchimp_cached.lists_member_info(:id => id, :emails => emails)
    end
  end

  c.desc 'Get all of the list members for a list that are of a particular status.'
  c.command :members do |s|
    s.desc 'list id'
    s.flag :id
    s.flag :limit, :default_value => 25

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_members(:id => id, :limit => options[:limit])['data'], :fields => [:email, :member_rating, :status, :is_gmonkey]
    end
  end

  c.desc 'Subscribe the provided email to a list. By default this sends a confirmation email.'
  c.arg_name 'emails'
  c.command :subscribe do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      #TODO: add support for merge fields
      #TODO: add support for location
      s.flag 'new-email'
      s.flag 'group-id'
      s.flag 'group-name'
      s.flag :groups
      s.flag 'optin-ip'
      s.flag 'optin-time'
      s.flag :language
      s.flag :note
      s.flag 'note-id'
      s.flag 'note-action'

      s.flag 'email-type'
      s.switch 'double-optin'
      s.switch 'update-existing'
      s.switch 'replace-interests'
      s.switch 'send-welcome'

      id = required_argument(:id, options[:id], global[:list])
      emails = create_email_struct(required_argument("Need to provide one or more email addresses.", args))
      @output.as_hash @mailchimp.lists_subscribe(:id => id, :email => emails.first, :merge_vars => {:groupings => [{:id => 4493, :groups => ['Group1']}]})
    end
  end

  c.desc 'Get all of the merge variables for a list.'
  c.command 'merge-vars' do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_merge_vars(:id => [id])['data'].first['merge_vars']
    end
  end

  c.desc 'Retrieve all of the Static Segments for a list.'
  c.command 'static-segments' do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.as_hash @mailchimp_cached.lists_static_segments(:id => id)
    end
  end

  c.desc 'Retrieve all of the Static Segments for a list.'
  c.command 'segments' do |s|
    s.desc 'list id'
    s.flag :id

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.as_hash @mailchimp_cached.lists_segments(:id => id)
    end
  end
end

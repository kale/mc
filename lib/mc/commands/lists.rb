desc 'View information about lists and subscribers'
arg_name 'Describe arguments to lists here'

command :lists do |c|
  c.desc 'List ID'
  c.flag :id

  c.desc 'Email Adress'
  c.flag :email

  c.desc 'Page number to start at'
  c.flag :start, :default_value => 0

  c.desc 'Retrieve all of the lists defined for your user account.'
  c.command :list do |s|
    s.action do |global,options,args|
      stats_column = lambda{|l| "#{l['stats']['member_count']} / #{na(l['stats']['open_rate'])} / #{na(l['stats']['click_rate'])}"}
      @output.standard @mailchimp_cached.lists_list['data'], :fields => [:id, :name, {"count / open % / click %" => stats_column}]
    end
  end

  c.desc 'Access up to the previous 180 days of daily detailed aggregated activity stats for a given list.'
  c.command :activity do |s|
    s.action do |global,options,args|
      id = required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_activity(:id => id)
    end
  end

  c.desc "Retrieve the clients that the list's subscribers have been tagged as being used based on user agents seen."
  c.command :clients do |s|
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

  c.desc 'Get all of the merge variables for a list.'
  c.command 'merge-vars' do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_merge_vars(:id => [id])['data'].first['merge_vars']
    end
  end

  c.desc 'Get all of the list members for a list that are of a particular status.'
  c.command :members do |s|
    s.flag :limit, :default_value => 25

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_members(:id => id, :limit => limit)['data'], :fields => [:email, :member_rating, :status, :is_gmonkey]
    end
  end

  c.desc 'Get information about one particular member.'
  c.command 'member-info' do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      emails = create_email_struct(required_argument("Need to provide one or more email addresses.", args))

      @output.as_hash @mailchimp_cached.lists_member_info(:id => id, :emails => emails)
    end
  end

  c.desc 'Retrieve the locations (countries) that the list\'s subscribers have been tagged to based on geocoding their IP address.'
  c.command :locations do |s|
    s.flag :num, :default_value => 25

    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      @output.standard @mailchimp_cached.lists_locations(:id => id)[0..options[:num].to_i]
    end
  end

  c.desc 'Access the Growth History by Month for a given list.'
  c.command :growth do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:list])
      # @output.standard @mailchimp_cached.lists_growth_history(:id => id), :fields => [:month, :existing, :optins]
      @output.standard @mailchimp_cached.lists_growth_history(:id => id)
    end
  end
end

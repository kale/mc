desc 'View information about lists and subscribers'
arg_name 'Describe arguments to lists here'

# all list commands will be cached
skips_pre

command :list do |c|
  c.desc 'List ID'
  c.flag :id

  c.desc 'Email Adress'
  c.flag :email

  c.desc 'Page number to start at'
  c.flag :start, :default_value => 0

  c.desc 'The number of results to return'
  c.flag :limit, :default_value => 100

  c.desc 'Retrieve all of the lists defined for your user account.'
  c.command :lists do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      cli_print @mailchimp.lists, [:id, :name]#, view_to_print(global, [:id, :name, :list_rating, :stats => :member_count], {:show_header => true})
    end
  end

  c.desc 'Access up to the previous 180 days of daily detailed aggregated activity stats for a given list.'
  c.command :activity do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_activity(:id => id), :all
    end
  end

  c.desc 'Access up to the previous 180 days of daily detailed aggregated activity stats for a given list.'
  c.command :clients do |s|
    s.action do |global,options,args|
      not_implemented
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_clients(:id => id)
    end
  end

  c.desc 'Get all of the merge variables for a list.'
  c.command :mergevars do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_merge_vars(:id => id), :all
    end
  end

  c.desc 'Get all of the list members for a list that are of a particular status.'
  c.command :members do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_members(:id => id, :start => options[:start], :limit => options[:limit]), :email, :show_index => false
    end
  end

  c.desc 'Get information about one particular member.'
  c.command :memberinfo do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_member_info(:id => id, :email_address => options[:email]), :all
    end
  end

  c.desc 'Retrieve the locations (countries) that the list\'s subscribers have been tagged to based on geocoding their IP address.'
  c.command :locations do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_locations(:id => id), [:country, :percent, :total]
    end
  end

  c.desc 'Access the Growth History by Month for a given list.'
  c.command :growth do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_growth_history(:id => id), [:month, :existing, :optins]
    end
  end
end

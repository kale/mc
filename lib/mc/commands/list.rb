desc 'View information about lists and subscribers'
arg_name 'Describe arguments to lists here'
command :list do |c|
  c.desc 'List ID'
  c.flag :id

  c.desc 'Page number to start at'
  c.flag :start, :default_value => 0

  c.desc 'The number of results to return'
  c.flag :limit, :default_value => 100

  c.desc 'Retrieve all of the lists defined for your user account.'
  c.command :lists do |s|
    s.action do
      cli_print @mailchimp.lists, [:id, :name, :list_rating, :stats => :member_count], {:show_header => true}
    end
  end

  c.desc 'Access up to the previous 180 days of daily detailed aggregated activity stats for a given list.'
  c.command :activity do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_activity(:id => id), :all
    end
  end

  c.desc 'Access up to the previous 180 days of daily detailed aggregated activity stats for a given list.'
  c.command :clients do |s|
    s.action do |global,options,args|
      not_implemented
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_clients(:id => id)
    end
  end

  c.desc 'Get all of the list members for a list that are of a particular status.'
  c.command :members do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_members(:id => options[:id], :start => options[:start], :limit => options[:limit]), [:email]
    end
  end

  c.desc 'Retrieve the locations (countries) that the list\'s subscribers have been tagged to based on geocoding their IP address.'
  c.command :locations do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_locations(:id => options[:id]), [:country, :percent, :total]
    end
  end

  c.desc 'Access the Growth History by Month for a given list.'
  c.command :growth do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      cli_print @mailchimp.list_growth_history(:id => options[:id]), [:month, :existing, :optins]
    end
  end
end
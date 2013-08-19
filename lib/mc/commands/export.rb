desc 'Export'
command :export do |c|
  c.desc 'List ID'
  c.flag :id

  # list ( string apikey, string id, string status array segment string since )
  c.desc 'Exports/dumps members of a list and all of their associated details.'
  c.command :list do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      puts @mailchimp.export_list(id)
    end
  end

  # helper/search-members (string apikey, string query, string id, int offset)
  c.desc 'Search account wide or on a specific list using the specified query terms'
  c.command :members do |s|
    s.action do |global,options,args|
      cli_search_results @mailchimp_cached.helper_search_members(:query => options[:q])
    end
  end
end


desc 'Search campaigns and members'
command :search do |c|
  # helper/search-campaigns (string apikey, string query, int offset, string snip_start, string snip_end)
  c.desc 'Search all campaigns for the specified query terms'
  c.command :campaigns do |s|
    s.action do |global,options,args|
      campaigns = required_argument("You need to include a search argument: mc search campaigns <query terms>", args.join(' '))
      @output.search @mailchimp_cached.helper_search_members(:query => query)
    end
  end

  # helper/search-members (string apikey, string query, string id, int offset)
  c.desc 'Search account wide or on a specific list using the specified query terms'
  c.command :members do |s|
    s.action do |global,options,args|
      query = required_argument("You need to include a search argument: mc search members <query terms>", args.join(' '))
      @output.search @mailchimp_cached.helper_search_members(:query => query)
    end
  end
end


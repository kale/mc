desc 'Search campaigns and members'
command :search do |c|
  # helper/search-campaigns (string apikey, string query, int offset, string snip_start, string snip_end)
  c.desc 'Search all campaigns for the specified query terms'
  c.command :campaigns do |s|
    s.action do |global,options,args|
      query = required_argument("You need to include a search argument: mc search campaigns <query terms>", args.join(' '))
      @output.campaign_search @mailchimp_cached.helper_search_campaigns(:query => query)
    end
  end

  # helper/search-members (string apikey, string query, string id, int offset)
  c.desc 'Search account wide or on a specific list using the specified query terms'
  c.command :members do |s|
    s.desc 'list id'
    s.flag :id

    s.desc 'Show number of matches only'
    s.switch 'count-only'

    s.action do |global,options,args|
      query = required_argument("You need to include a search argument: mc search members <query terms>", args.join(' '))
      id = required_option(:id, options[:id], global[:list])

      results = @mailchimp_cached.helper_search_members(:query => query, :id => id)
      full_search_members = results['full_search']['members']
      full_search_count = results['full_search']['total'].to_i
      exact_search_count = results['exact_matches']['total'].to_i

      if full_search_count > 100
        (full_search_count / 100).times {|n| full_search_members << @mailchimp_cached.helper_search_members(:query => query, :id => id, :offset => (n+1)*100)['full_search']['members']}
      end

      if options['count-only']
        puts "Total exact matches for '#{query}' = #{results['exact_matches']['total']}" if exact_search_count > 0
        puts "Total matches for '#{query}' = #{full_search_count}" if full_search_count > 0
      else
        @output.member_search results['exact_matches']['members'], full_search_members.flatten, global
      end
    end
  end
end

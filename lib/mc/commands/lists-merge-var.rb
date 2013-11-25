command :lists do |lists|
  lists.desc 'Manage merge tags'
  lists.command 'merge-vars' do |c|
    # # lists/merge-var-add (string apikey, string id, string tag, string name, struct options)
    # c.desc 'Add a new merge tag to a given list'
    # c.command :add do |s|
    #   s.action do |global,options,args|
    #   end
    # end

    # # lists/merge-var-del (string apikey, string id, string tag)
    # c.desc 'Delete a merge tag from a given list and all its members'
    # c.long_desc <<EOS
    # Seriously - the data is removed from all members as well! Note that on large lists this method may seem a bit slower than calls you typically make.
# EOS
    # c.command :delete do |s|
    #   s.action do |global,options,args|
    #   end
    # end

    # # lists/merge-var-reset (string apikey, string id, string tag)
    # c.desc 'Completely resets all data stored in a merge var on a list.'
    # c.command :reset do |s|
    #   s.action do |global,options,args|
    #   end
    # end

    # # lists/merge-var-set (string apikey, string id, string tag, string value)
    # c.desc 'Completely resets all data stored in a merge var on a list.'
    # c.command :reset do |s|
    #   s.action do |global,options,args|
    #   end
    # end

    # # lists/merge-var-update (string apikey, string id, string tag, struct options)
    # c.desc 'Completely resets all data stored in a merge var on a list.'
    # c.command :reset do |s|
    #   s.action do |global,options,args|
    #   end
    # end

    # lists/merge-vars (string apikey, array id)
    c.desc 'Get the list of merge tags for a given list, including their name, tag, and required setting'
    c.command :list do |s|
      s.desc 'List ID'
      s.flag :id

      s.action do |global,options,args|
        id = required_option(:id, options[:id], global[:list])
        @output.standard @mailchimp_cached.lists_merge_vars(:id => [id])['data'].first['merge_vars']
      end
    end

    c.default_command :list
  end
end

command :lists do |lists|
  lists.desc 'Manage groups'
  lists.command :group do |c|
    # lists/interest-group-add (string apikey, string id, string group_name, int grouping_id)
    c.desc 'Add a single Interest Group'
    c.command :add do |s|
      s.desc 'list id'
      s.flag :id
      s.flag 'grouping-id'

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        group_name = required_argument("Need to provide a group name.", args).first

        @output.standard @mailchimp.lists_interest_group_add(:id => id, :group_name => group_name, :grouping_id => options['grouping-id'])
      end
    end

    # lists/interest-group-del (string apikey, string id, string group_name, int grouping_id)
    c.desc 'Delete a single Interest Group'
    c.command :delete do |s|
      s.desc 'list id'
      s.flag :id
      s.flag 'grouping-id'

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        group_name = required_argument("Need to provide a group name.", args).first
        @output.standard @mailchimp.lists_interest_group_delete(:id => id, :group_name => group_name, :grouping_id => options['grouping-id'])
      end
    end

    # lists/interest-group-update (string apikey, string id, string old_name, string new_name, int grouping_id)
    c.desc 'Change the name of an Interest Group'
    c.command :update do |s|
      s.desc 'list id'
      s.flag :id
      s.flag :old
      s.flag :new
      s.flag 'grouping-id'

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        @output.standard @mailchimp.lists_interest_group_delete(:id => id, :old_name => options[:old], :new_name => options[:new], :grouping_id => options['grouping-id'])
      end
    end
  end

  lists.desc 'Manage groupings'
  lists.command :grouping do |c|
    # lists/interest-grouping-add (string apikey, string id, string name, string type, array groups)
    c.desc 'Add a new Interest Grouping'
    c.arg_name 'groups'
    c.command :add do |s|
      s.desc 'list id'
      s.flag :id

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        @output.standard @mailchimp_cached.lists_grouping_add(:id => id, :name => options[:name], :type => options[:type])
      end
    end

    # lists/interest-grouping-del (string apikey, int grouping_id)
    c.desc 'Delete an existing Interest Grouping'
    c.command :delete do |s|
      s.desc 'list id'
      s.flag :id

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        emails = create_email_struct(required_argument("Need to provide one or more email addresses.", args))
        @output.standard @mailchimp_cached.lists_
      end
    end

    # lists/interest-grouping-update (string apikey, int grouping_id, string name, string value)
    c.desc 'Update an existing Interest Grouping'
    c.command :update do |s|
      s.flag :grouping_id
      s.flag :name
      s.flag :value

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        @output.standard @mailchimp_cached.lists_interest_grouping_update(:grouping_id => options[:grouping_id], :name => options[:name], :value => options[:value])
      end
    end

    # lists/interest-groupings (string apikey, string id, bool counts)
    c.desc 'Get the list of interest groupings for a given list, including the label, form information, and included groups for each'
    c.command :list do |s|
      s.desc 'list id'
      s.flag :id
      s.switch :counts, :default_value => false

      s.action do |global,options,args|
        id = required_argument(:id, options[:id], global[:list])
        @output.standard @mailchimp_cached.lists_interest_groupings(:id => id, :counts => options[:counts])
      end
    end

    c.default_command :list
  end
end

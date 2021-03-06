desc 'Manage templates within your account'

command :templates do |c|
  # templates/list (string apikey, struct types, struct filters)
  c.desc 'Retrieve various templates available in the system'
  c.command :list do |s|
    s.action do |global,options,args|
      @output.standard @mailchimp_cached.templates_list
    end
  end
end

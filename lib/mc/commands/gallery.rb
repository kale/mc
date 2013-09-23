# desc 'View information about lists and subscribers'
# arg_name 'Describe arguments to lists here'

command :gallery do |c|
  # list(string apikey, struct opts)
  c.desc 'Return a section of the image gallery'
  c.command :list do |s|
    s.action do |global,options,args|
      @output.standard @mailchimp_cached.gallery_list
    end
  end
end

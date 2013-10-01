desc 'Manage images and documents that are in your account'

command :gallery do |c|
  # list(string apikey, struct opts)
  c.desc 'Return a section of the image gallery'
  c.command :list do |s|
    s.action do |global,options,args|
      @output.standard @mailchimp_cached.gallery_list['data'], :fields => [{"full path" => {:display_method => :full, :width => 100}}]
    end
  end
end

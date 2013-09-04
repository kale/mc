desc 'Campaign related tasks'
command :campaigns do |c|

  c.desc 'Create Campaign'
  c.command :create do |s|
    c.desc 'List ID'
    c.flag [:id]

    c.desc 'Subject'
    c.flag [:subject]

    c.desc 'From email'
    c.flag [:from_email]
    
    c.desc 'From name'
    c.flag [:from_name]

    c.desc 'To name'
    c.flag [:to_name]

    c.desc 'Template ID'
    c.flag [:template_id] 

    c.desc 'Gallery template ID'
    c.flag [:gallery_template_id] 

    c.desc 'Base template ID'
    c.flag [:base_template_id] 

    c.desc 'Folder ID'
    c.flag [:folder_id] 

    #c.desc 'Tracking'
    #c.flag [:tracking] 

    c.desc 'Title - internal name to use'
    c.flag [:title]

    c.desc 'authenticate'
    c.flag [:authenticate], :default => true

    #c.desc 'Analytics'
    #c.flag [:analytics]

    c.desc 'Auto footer?'
    c.switch :auto_footer, :default => false

    c.desc 'Inline css?'
    c.switch :inline_css, :default => false

    c.desc 'Auto tweet?'
    c.switch :tweet, :default => false

    #c.desc 'Auto FB post'
    #c.flag [:auto_fb_post]

    c.desc 'FB comments?'
    c.switch :fb_comments, :default => false

    c.desc 'HTML filename'
    c.flag [:html_filename]

    c.desc 'TXT filename'
    c.flag [:text_filename]

    c.desc 'segmentation options [NAME,VALUE]'
    c.flag [:seg_options]

    c.desc 'Campaign ID'
    c.flag [:cid]

    c.desc 'Send Campaign Now'
    c.switch [:sendnow]

    c.desc 'Schedule Campaign'
    c.switch [:schedule]

    c.desc 'Send Test Campaign'
    c.switch [:sendtest]    

    s.action do |global,options,args|
      if options[:seg_options]
        field, value = options[:seg_options].split(",") if options[:seg_options]
        options[:seg_options] = [{:field => field, :op => "like", :value => value}]
      end

      puts "Campaign created: #{@mailchimp.campaign_create(options, options[:seg_options])}"
    end
  end

  c.desc 'Send Campaign Now'
  c.command :sendnow do |s|
    s.action do |global,options,args|
      campaign_id = options[:cid] || @mailchimp.cache.get(:campaign_id)
      throw "Need a valid Campaign ID." if campaign_id.nil?

      puts @mailchimp.campaign_send_now(:cid => campaign_id)
    end
  end

  c.desc 'Schedule Campaign'
  c.command :schedule do |s|
    s.action do |global,options,args|
      campaign_id = options[:cid] || @campaign_id
      #TODO: fix this
      puts @mailchimp.campaign_schedule(:cid => campaign_id, :schedule_time => "2012-10-24 08:15:00")
    end
  end

  c.desc 'Send Test Campaign'
  c.command :sendtest do |s|
    s.action do |global,options,args|
      campaign_id = options[:cid] || @mailchimp.cache.get(:campaign_id)
      throw "Need a valid Campaign ID." if campaign_id.nil?

      puts "Sending test for campaign #{campaign_id}..."
      puts @mailchimp.campaign_send_test(:cid=> campaign_id, :test_emails => ["kale.davis@gmail.com", "kale@simplerise.com"])
    end
  end  

  c.desc 'Delete Campaign'
  c.command :delete do |s|
    s.action do |global,options,args|
      campaign_id = options[:cid] || @mailchimp.cache.get(:campaign_id)
      throw "Need a valid Campaign ID." if campaign_id.nil?

      campaign_delete(:cid=> campaign_id)
      puts "Deleted campaign #{campaign_id}."
    end
  end  

  c.desc 'Get the list of campaigns and their details matching the specified filters'
  c.command :list do |s|
    s.switch :first
    s.action do |global,options,args|
      if options[:first]
        puts @mailchimp_cached.campaigns_list["data"].first
      else
        cli_print @mailchimp_cached.campaigns_list, :all
      end
    end
  end
end

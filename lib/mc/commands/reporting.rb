desc 'Reporting'
command [:reporting, :r] do |c|

  c.desc 'List ID'
  c.flag :id

  c.desc 'Year'
  c.flag :year

  c.desc 'Start'
  c.flag :start

  c.desc 'Last campaign stats'
  c.command :cstat do |s|
    s.action do |global,options,args|
      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})      
      Report::CampaignStats.new(@mailchimp, options[:start]).run
    end
  end

  c.desc 'Zeitgest - top links by year'
  c.command :zeitgest do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])

      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})      
      Report::Zeitgest.new(@mailchimp, id, options[:year]).run
    end
  end

  c.desc 'Archive urls'
  c.command :archiveurls do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])

      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})      
      Report::ArchiveUrls.new(@mailchimp, id).run
    end
  end

  c.desc 'Total clicks for past campaigns'
  c.command :totalclicks do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])

      @mailchimp = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})      
      Report::TotalClicks.new(@mailchimp, id).run
    end
  end
end

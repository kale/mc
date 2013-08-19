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
      Report::CampaignStats.new(@mailchimp_cached, options[:start]).run
    end
  end

  c.desc 'Zeitgest - top links by year'
  c.command :zeitgest do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      Report::Zeitgest.new(@mailchimp_cached, id, options[:year]).run
    end
  end

  c.desc 'Archive urls'
  c.command :archiveurls do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      Report::ArchiveUrls.new(@mailchimp_cached, id).run
    end
  end

  c.desc 'Total clicks for past campaigns'
  c.command :totalclicks do |s|
    s.action do |global,options,args|
      id = get_required_argument(:id, options[:id], global[:default_list])
      Report::TotalClicks.new(@mailchimp_cached, id).run
    end
  end
end

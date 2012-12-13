require 'gibbon'

class MailChimp
  def initialize(apikey, options={})
  	#setup Gibbon
    @api = Gibbon.new(apikey)
    @api.throws_exceptions = true
    @options = options
  end

  def ping
    if @api.ping == "Everything's Chimpy!"
    	"Everything's Chimpy!"
    else
    	"Yikes, can't connect!"
    end
  end

  def campaign_create(list_id, subject, html_filename, text_filename, segment_conditions)
    # campaignCreate(string type, array options, array content, array segment_opts, array type_opts)
    type = "regular"
    opts = {:list_id => list_id,
            :subject => subject,
            :from_email => "kale@hackernewsletter.com",
            :from_name => "Kale Davis",
            :inline_css => true,
            #:tracking => ['opens' => true, 'html_clicks' => true, 'text_clicks' => false],
            :authenticate => true,
            :analytics => ['google' => 'KEY']}

    content = {"html" => File.open(html_filename).read, "text" => File.open(text_filename).read}

    segment_opts = {:match => "all", :conditions => segment_conditions}
    
    campaign_id = @api.campaign_create(:type => type, :options => opts, :content => content)
    @cache.set(:campaign_id, campaign_id)

    return campaign_id
  end

  private

  def method_missing (method_name, *args)  
    puts "method missing: '#{method_name}' - #{args}" if @options[:debug]
    @api.send(method_name, *args)
  end
end
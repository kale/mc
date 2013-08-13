require 'gibbon'
require 'filecache'

class MailChimp
  def initialize(apikey, options={})
    @api = Gibbon::API.new(apikey)
    @api.throws_exceptions = true
    @options = options
  end

  def ping
    if @api.helper.ping['msg'] == "Everything's Chimpy!"
      "Everything's Chimpy!"
    else
      "Yikes, can't connect!"
    end
  end

  def campaign_create(options, segment_conditions)
    # campaignCreate(string type, array options, array content, array segment_opts, array type_opts)
    type = "regular"
    opts = {:list_id => options[:id],
            :subject => options[:subject],
            :from_email => options[:from_email],
            :from_name => options[:from_name],
            :inline_css => true,
            #:tracking => ['opens' => true, 'html_clicks' => true, 'text_clicks' => false],
            :authenticate => true,
            :analytics => ['google' => 'KEY']}

    content = {"html" => File.open(options[:html_filename]).read, "text" => File.open(options[:text_filename]).read}

    segment_opts = {:match => "all", :conditions => segment_conditions} unless segment_conditions.nil?
    
    campaign_id = @api.campaign_create(:type => type, :options => opts, :content => content, :segment_opts => segment_opts)
    #campaign_id = MailChimpCached.cache_value("campaign_id", "tttest")
    return campaign_id
  end

  private

  def method_missing (method_name, *args)  
    category = method_name.to_s.split('_').first
    method   = method_name.to_s.split('_')[1..-1].join('_')
    @api.send(category).send(method, *args)
  end
end

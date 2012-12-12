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

  private

  def method_missing (method_name, *args)  
    puts "method missing: '#{method_name}' - #{args}" if @options[:debug]
    @api.send(method_name, *args)
  end
end
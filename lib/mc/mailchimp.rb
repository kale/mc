require 'gibbon'

class MailChimp
  def initialize(apikey, reset_cache=false)
  	#setup Gibbon
    @api = Gibbon.new(apikey)
    @api.throws_exceptions = true
  end

  def ping
    if @api.ping == "Everything's Chimpy!"
    	"Everything's Chimpy!"
    else
    	"Yikes, can't connect!"
    end
  end
end
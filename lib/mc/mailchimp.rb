require 'gibbon'
require 'filecache'

class MailChimp
  def initialize(apikey, options={})
    @api = Gibbon::API.new(apikey)
    @api.throws_exceptions = true
    @options = options

    @exporter = @api.get_exporter
  end

  def method_missing(method_name, *args)
    puts "DEBUG: Calling '#{method_name}(#{args})'..." if @options[:debug]
    category = method_name.to_s.split('_').first
    method   = method_name.to_s.split('_')[1..-1].join('_')
    if category == "export"
      @exporter.send(method, *args)
    else
      if method == 'send'
        # handle wonk case of 'send' method
        @api.send(category).send(*args)
      else
        # had to change this from .send(method, *args) to .method_missing b/c of gibbon 1.0.3
        @api.send(category).method_missing(method, *args)
      end
    end
  end
end

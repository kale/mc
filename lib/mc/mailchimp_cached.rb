require 'gibbon'
require 'filecache'
require 'digest/sha1'

class MailChimpCached < MailChimp

  def initialize(apikey, options={})
    super(apikey, options)

    # configure filecache
    cache_dir = File.join(File.expand_path(ENV['HOME']), ".mailchimp-cache")

    # expire in one hour
    expiry = 60 * 60

    @cache = FileCache.new(apikey, cache_dir, expiry)
  end

  private

  def method_missing (method_name, *args)
    puts "method missing: '#{method_name}' - #{args}" if @options[:debug]

    cache_key = Digest::SHA1.hexdigest(method_name.to_s + args.to_s)

    if result = @cache.get(cache_key)
      return result
    else
      result = @api.send(method_name, *args)
      @cache.set(cache_key, result)
      return result
    end
  end
end

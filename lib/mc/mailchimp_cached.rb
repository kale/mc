require 'gibbon'
require 'filecache'
require 'digest/sha1'

class MailChimpCached < MailChimp

  def initialize(apikey, options={})
    super(apikey, options)

    # configure filecache
    cache_dir = File.join(File.expand_path(ENV['HOME']), ".mailchimp-cache")

    # expire in one day
    expiry = 60 * 60 * 24

    @cache = FileCache.new(apikey, cache_dir, expiry)
    @reset = options[:reset_cache]
  end

  def cache_value(key, value)
    puts "cache returns: #{@cache.set(key, value)}"
  end

  private

  def method_missing (method_name, *args)
    cache_key = Digest::SHA1.hexdigest(method_name.to_s + args.to_s)

    if result = @cache.get(cache_key) and not @reset
      return result
    else
      result = @api.send(method_name, *args)
      @cache.set(cache_key, result)
      return result
    end
  end
end

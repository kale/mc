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
    @skip_cache = options[:skip_cache]
  end

  def cache_value(key, value)
    puts "cache returns: #{@cache.set(key, value)}"
  end

  private

  def method_missing(method_name, *args)
    puts "DEBUG: Calling '#{method_name}(#{args})'..." if @options[:debug]
    cache_key = Digest::SHA1.hexdigest(method_name.to_s + args.to_s)

    if result = @cache.get(cache_key) and not @skip_cache
      puts "DEBUG: USING CACHED RESULT" if @options[:debug]
      return result
    else
      category = method_name.to_s.split('_').first
      method   = method_name.to_s.split('_')[1..-1].join('_')

      throw "error: don't support caching export" if category == "export"
      throw "error: don't support caching send" if method == "send"

      result = @api.send(category).method_missing(method, *args)
      @cache.set(cache_key, result)

      return result
    end
  end
end

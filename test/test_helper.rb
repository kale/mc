def config
  config_file = ENV['HOME']+'/.mailchimp'
  raise "Need config file to pull API key from." unless File.exists?(config_file)
  config_hash = YAML.load(File.open(config_file))

  raise "Need to set :test_api_key in config file" unless config_hash.has_key? :test_api_key
  raise "Need to set :test_list_id in config file" unless config_hash.has_key? :test_list_id

  return config_hash
end

def cached_dir
  ENV['HOME']+'/.mailchimp-cache'
end

def clear_cached_dir
  # delete cache dir
  FileUtils.rm_rf(cached_dir)
end

def get_random_email_address
  "test+#{rand(1000..9999)}@gmail.com"
end

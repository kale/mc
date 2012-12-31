def config
  config_file = ENV['HOME']+'/.mailchimp'
  raise "Need API key for testing" unless File.exists?(config_file)
  YAML.load(File.open(config_file))
end

def cached_dir
  ENV['HOME']+'/.mailchimp-cache'
end

def clear_cached_dir
  # delete cache dir
  FileUtils.rm_rf(cached_dir)
end

def get_random_email_address
  "test+#{rand(1000..9999)}@kaledavis.com"
end

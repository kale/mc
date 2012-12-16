def config
	config_file = ENV['HOME']+'/.mailchimp'
	raise "Need API key for testing" unless File.exists?(config_file)
	YAML.load(File.open(config_file))
end

def cached_dir
	ENV['HOME']+'/.mailchimp-cache'
end
require 'minitest/spec'
require 'minitest/autorun'
require 'rubygems'
require 'mc'

describe "MC" do
	before do
		config_file = ENV['HOME']+'/.mailchimp'
		raise "Need API key for testing" unless File.exists?(config_file)
		config = YAML.load(File.open(config_file))
		
		@mailchimp = MailChimp.new(config[:apikey])
	end

  it "should be able to ping MailChimp" do
    @mailchimp.ping.must_equal "Everything's Chimpy!"
  end
end
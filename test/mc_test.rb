require 'minitest/spec'
require 'minitest/autorun'
require 'yaml'
require 'mc'
require_relative 'test_helper'

describe "MailChimp" do
	before do
		@mailchimp = MailChimp.new(config[:apikey])
		@test_list_id = "ef4227fc80	"
	end

  it "should be able to ping MailChimp" do
    @mailchimp.ping.must_equal "Everything's Chimpy!"
  end

  it "should pass to method_missing" do
  	@mailchimp.lists.count.must_be :>, 0
  end
end

describe "MailChimpCached" do
	before do
		@mailchimp = MailChimpCached.new(config[:apikey])
	end

  it "should be able to ping MailChimp" do
    @mailchimp.ping.must_equal "Everything's Chimpy!"
  end

  it "should pass to method_missing" do
  	@mailchimp.lists.count.must_be :>, 0
  end

  it "should create a cache dir" do
  	# delete cache dir
  	FileUtils.rm_rf(cached_dir)
  	File.exists?(cached_dir).must_equal false

  	@mailchimp.lists.count

  	File.exists?(cached_dir).must_equal true
  end
end
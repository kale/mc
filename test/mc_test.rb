require 'minitest/spec'
require 'minitest/autorun'
require 'yaml'
require 'mc'
require_relative 'test_helper'

describe "MailChimp" do
  before do
    @mailchimp = MailChimp.new(config[:apikey])
    @test_list_id = "ef4227fc80"
  end

  it "should be able to ping MailChimp" do
    @mailchimp.ping.must_equal "Everything's Chimpy!"
  end

  it "should pass to method_missing" do
  	@mailchimp.lists.count.must_be :>, 0
  end

  it "should see updated results" do
    email = get_random_email_address
    #see how many subscribers the test list has
    count = @mailchimp.list_members(:id => @test_list_id)["total"].to_i
    count.must_be :>=, 0

    #add a new subscriber and make sure the count increases by one
    @mailchimp.list_subscribe(:id => @test_list_id, :email_address => email, :double_optin => false)
    new_count = @mailchimp.list_members(:id => @test_list_id)["total"].to_i
    new_count.must_equal count + 1

    # remove subscriber to reset list
    @mailchimp.list_unsubscribe(:id => @test_list_id, :email_address => email, :delete_member => true)
  end
end

describe "MailChimpCached" do
  before do
    @mailchimp = MailChimpCached.new(config[:apikey])
    @test_list_id = "ef4227fc80"
    clear_cached_dir
  end

  it "should not have a cached dir already" do
  	@mailchimp.lists.count
 	File.exists?(cached_dir).must_equal true
    clear_cached_dir
 	File.exists?(cached_dir).must_equal false
  end

  it "should be able to ping MailChimp" do
    @mailchimp.ping.must_equal "Everything's Chimpy!"
  end

  it "should pass to method_missing" do
  	@mailchimp.lists.count.must_be :>, 0
  end

  it "should create a cache dir" do
  	File.exists?(cached_dir).must_equal false

  	@mailchimp.lists.count

  	File.exists?(cached_dir).must_equal true
  end

  it "should pull cached results when" do
    email = get_random_email_address

    count = @mailchimp.list_members(:id => @test_list_id)["total"].to_i
    count.must_be :>=, 0
    @mailchimp.list_subscribe(:id => @test_list_id, :email_address => email, :double_optin => false)
    new_count = @mailchimp.list_members(:id => @test_list_id)["total"].to_i
    new_count.must_equal count
    
    clear_cached_dir

    new_count = @mailchimp.list_members(:id => @test_list_id)["total"].to_i
    new_count.must_equal count + 1

    # remove subscriber to reset list
    @mailchimp.list_unsubscribe(:id => @test_list_id, :email_address => email, :delete_member => true)
  end
end

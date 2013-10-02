require 'minitest/spec'
require 'minitest/autorun'
require 'yaml'
require 'mc'
require_relative 'test_helper'

describe "MailChimp" do
  before do
    @mailchimp = MailChimp.new(config[:apikey])
    @test_list_id = config[:test_list_id]
  end

  it "should be able to ping MailChimp" do
    @mailchimp.helper_ping['msg'].must_equal "Everything's Chimpy!"
  end

  it "should pass to method_missing" do
    @mailchimp.lists_list.count.must_be :>, 0
  end

  it "should see updated results" do
    email = get_random_email_address
    #see how many subscribers the test list has
    count = @mailchimp.lists_members({:id => @test_list_id})["total"].to_i
    count.must_be :>=, 0

    #add a new subscriber and make sure the count increases by one
    @mailchimp.lists_subscribe(:id => @test_list_id, :email => {:email => email}, :double_optin => false)
    new_count = @mailchimp.lists_members(:id => @test_list_id)["total"].to_i
    new_count.must_equal count + 1

    # remove subscriber to reset list
    @mailchimp.lists_unsubscribe(:id => @test_list_id, :email => {:email => email}, :delete_member => true)
  end
end

describe "MailChimpCached" do
  before do
    @mailchimp_cached = MailChimpCached.new(config[:apikey])
    @test_list_id = config[:test_list_id]
    clear_cached_dir
  end

  it "should not have a cached dir already" do
  	@mailchimp_cached.lists_list.count
 	File.exists?(cached_dir).must_equal true
    clear_cached_dir
 	File.exists?(cached_dir).must_equal false
  end

  it "should be able to ping MailChimp" do
    @mailchimp_cached.helper_ping['msg'].must_equal "Everything's Chimpy!"
  end

  it "should pass to method_missing" do
  	@mailchimp_cached.lists_list.count.must_be :>, 0
  end

  it "should create a cache dir" do
  	File.exists?(cached_dir).must_equal false

  	@mailchimp_cached.lists_list.count

  	File.exists?(cached_dir).must_equal true
  end

  it "should pull cached results when" do
    clear_cached_dir
    email = get_random_email_address

    count = @mailchimp_cached.lists_members(:id => @test_list_id)["total"].to_i
    count.must_be :>=, 0
    @mailchimp_cached.lists_subscribe(:id => @test_list_id, :email => {:email => email}, :double_optin => false)
    new_count = @mailchimp_cached.lists_members(:id => @test_list_id)["total"].to_i
    new_count.must_equal count

    clear_cached_dir

    new_count = @mailchimp_cached.lists_members(:id => @test_list_id)["total"].to_i
    new_count.must_equal count + 1

    # remove subscriber to reset list
    @mailchimp_cached.lists_unsubscribe(:id => @test_list_id, :email => {:email => email},:delete_member => true)
  end
end

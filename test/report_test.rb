require 'minitest/spec'
require 'minitest/autorun'
require 'yaml'
require 'mc'
require_relative 'test_helper'

describe "Report" do
  before do
    @mailchimp = MailChimp.new(config[:apikey])
    @test_list_id = "e505c88a2e"
  end

  it "should output top 100 links for the year" do
    Report::Zeitgest.new(@mailchimp, @test_list_id, 2012).run
  end
end

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

When /^I run `(.*)` without a key or config file$/ do |app_name|
  @app_name = app_name
  config_file_name = ENV['HOME']+ '/.mailchimp'
  temp_file_name   = config_file_name + '-temp'

  File.rename(config_file_name, temp_file_name)
  step %(I run `#{app_name}`)
  File.rename(temp_file_name, config_file_name)
end

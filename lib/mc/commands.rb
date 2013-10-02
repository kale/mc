include GLI::App
include Helper

program_desc 'Command line interface to MailChimp. Eep eep!'

version MC::VERSION

config_file '.mailchimp'

desc 'Turn on debugging'
switch [:debug], :negatable => false

desc 'Do not use cached result'
switch [:skipcache], :negatable => false

desc 'MailChimp API Key'
arg_name 'apikey'
flag [:apikey]

desc 'Default list to use'
arg_name 'listID'
flag [:default_list]

desc 'formatted, raw, or awesome'
arg_name 'format'
flag [:output,:o], :default_value => "formatted"

commands_from "mc/commands"

pre do |global,command,options,args|
  # quit if no api
  raise "Must include MailChimp API key either via --apikey flag or config file." if global[:apikey].nil?

  # setup mailchimp api
  @mailchimp = MailChimp.new(global[:apikey], {:debug => global[:debug]})
  @mailchimp_cached = MailChimpCached.new(global[:apikey], {:debug => global[:debug], :skip_cache => global[:skipcache]})

  # create cli writer
  @output = ConsoleWriter.new(global)

  # setup debug
  @debug = true if global[:debug]

  true
end

post do |global,command,options,args|
end

on_error do |exception|
  puts exception.message

  if @debug then
    puts "\n"+"-"*20+"[ Backtrace: ]"+"-"*20
    exception.backtrace.each do |b|
      puts b
    end
  end
  false
end

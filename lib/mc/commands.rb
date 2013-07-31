include GLI::App
include Helper

program_desc 'Command line interface to MailChimp. Eep eep!'

version MC::VERSION

config_file '.mailchimp'

desc 'Turn on debugging'
switch [:debug], :negatable => false

desc 'Do not use cached result'
switch [:resetcache], :negatable => false

desc 'MailChimp API Key'
arg_name 'apikey'
flag [:apikey]

desc 'Default list to use'
arg_name 'listID'
flag [:default_list]

commands_from "mc/commands"

pre do |global,command,options,args|
  if global[:apikey].nil?
    raise "Must include MailChimp API key either via --apikey flag or config file."
  else
    @mailchimp = MailChimp.new(global[:apikey], {:debug => global[:debug], :reset_cache => global[:resetcache]})
  end

  if global[:debug]
  	@debug = true
  	puts "DEBUG ON"
  else
  	@debug = false
  end

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

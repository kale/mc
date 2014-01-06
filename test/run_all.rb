#!/user/bin/env ruby

RUN_COMMANDS = false
EXPORT_CMD = true

raise "Need to provide a list id" if ARGV.first.nil?

commands = %w(campaigns ecomm gallery helper lists reports search users vip)

def get_subcommands(help_text)
  subcommands = []
  commands = help_text.scan(/COMMANDS.*/m).first.split("\n")
  commands.shift #get rid of 'COMMANDS' header

  commands.each do |command|
    begin
      subcommands << command.strip.match(/^([a-z-]*) +-/)[1]
    rescue
      # skip multi-line command descriptions
    end
  end

  return subcommands
end

def run(command, run=false)
  global_options = "--list=#{ARGV.first}"
  subcommands = get_subcommands `bundle exec bin/mc #{command} --help`

  if command == 'lists'
    %w(group grouping merge-vars webhook).each do |subcommand|
      subsubcommands = []
      subsubcommands = get_subcommands `bundle exec bin/mc #{command} #{subcommand} --help`
      subsubcommands.each {|subsubcommand| subcommands << "#{subcommand} #{subsubcommand}"}
    end
  end

  puts "### #{'-'*30}"
  puts "### #{command.upcase} (#{subcommands.count})"
  puts "### #{'-'*30}"

  subcommands.each do |subcommand|
    puts "echo_and_run bundle exec bin/mc #{global_options} #{command} #{subcommand}"
    if run
      puts "bundle exec bin/mc #{global_options} #{command} #{subcommand}"
      puts '[[['
      puts "#{`bundle exec bin/mc #{global_options} #{command} #{subcommand}`}"
      puts ']]]'
      puts "\n---\n"
    end
  end
  puts "\n"
end

puts "echo_and_run() { echo \"\$ $@\" ; \"$@\" ; echo -e \"\\n\" ;}" if !RUN_COMMANDS

commands.each do |command|
  run command, RUN_COMMANDS
end

run('export', RUN_COMMANDS) if EXPORT_CMD

require 'awesome_print'
require 'table_print'

class ConsoleWriter
  def initialize(options)
    @options = options
    puts "*** DEBUG ON ***" if @options[:debug]
  end

  def standard(results, options={})
    redirect_output? results, options
    as_table results, options
  end

  def as_hash(results, options={})
    redirect_output? results, options

    if results.is_a? Hash and results.has_key? 'data'
      ap results['data'].first, options
    else
      ap results, options
    end
  end

  def as_table(results, options={})
    redirect_output? results, options

    results.reverse! if options[:reverse]
    tp results, options[:fields]
  end

  def as_raw(results)
    puts results
  end

  def errors(results)
    puts "Error count: #{results['error_count']}"
    results['errors'].each do |error|
      puts error['error']
    end
  end

  def flat_hash(hash, k = [])
    return {k => hash} unless hash.is_a?(Hash)
    hash.inject({}){ |h, v| h.merge! flat_hash(v[-1], k + [v[0]]) }
  end

  def as_formatted(results, options={})
    redirect_output? results, options

    # set default options
    options[:show_header] ||= true
    options[:show_index]  ||= false
    options[:debug]       ||= false

    fields = options[:fields]

    # find the correct staring level in the returned json
    if results.kind_of? Hash
      # array of hashes or just a single hash?
      if results["data"].nil?
        results = [results]
      else
        results = results["data"]
      end
    end

    if fields == :all
      fields = []
      results.first.each_key {|key| fields << key}
    end

    results.reverse! if options[:reverse]
    results = results[0..options[:limit]] if options[:limit]

    puts "Fields: #{[*fields].join(', ')}" unless fields.nil? || !options[:show_header]

    results.to_enum.with_index(1) do |item, index|
      if options[:debug] || fields.nil?
        puts "Number of items: #{results.count}"
        puts "Fields:"
        item.each do |k,v|
          if v.kind_of? Hash
            puts "#{k} ="
            v.each do |k,v|
              puts "     #{k} = #{v}"
            end
          elsif v.kind_of? Array
            puts "#{k} ="
            v.each do |i|
              if i.kind_of? Hash
                i.each do |k,v|
                  puts "     #{k} = #{v}"
                end
              else
                puts "     #{i}"
              end
            end
          else
            puts "#{k} = #{v}"
          end
        end
        return
      else
        values_to_print = []
        [*fields].each do |field|
          if field.class == Hash
            values_to_print << item[field.keys.first.to_s][field.values.first.to_s]
          else
            values_to_print << item[field.to_s]
          end
        end

        print "#{pad(index, results.count)} - " if options[:show_index]
        puts  "#{values_to_print.join(' ')}"
      end
    end
  end

  def campaign_search(results)
    if results['total'].to_i == 0
      exit_now!("No matches found.")
    end

    results['results'].each_with_index do |result, index|
      puts "#{'-'*15} [#{index+1}] #{'-'*15}"
      puts result['snippet'].strip.gsub(/\n/, ' ')
      puts "From campaign \"#{result['campaign']['title']}\" (#{result['campaign']['id']}) that was sent on #{result['campaign']['send_time'].split.first}"
      puts "\n"
    end
  end

  def member_search(exact, full, options=nil)
    redirect_output?(full, options)

    if exact.count == 0 and full.count == 0
      exit_now!("No matches found.")
    end

    members = []

    if exact.count > 0
      puts "#{'='*20} Exact Matches (#{exact.count}) #{'='*20}"

      exact.each do |member|
        members << member
      end

      tp members, :email, :id, :list_name, :member_rating, :status, "VIP?" => {:display_method => :is_gmonkey}
    elsif full.count > 0
      max_email = 0
      max_name = 0

      full.each do |member|
        members << member
        max_email = find_max(member['email'].size, max_email)
        max_name  = find_max(member['list_name'].size, max_name)
      end

      #display the table header
      header = "#{pad('EMAIL', max_email, 40)} | ID         | #{pad('LIST NAME', max_name, 20)} | MEMBER RATING | #{pad('STATUS', 12)} | VIP?"
      puts "#{'='*(header.size/2 - 7)} Matches (#{full.count}) #{'='*(header.size/2 - 7)}"
      header += "\n#{'-'*header.size}"
      puts header

      #display member rows
      members.each do |m|
        puts "#{pad(m['email'], max_email, 40)} | #{m['id']} | #{pad(m['list_name'], max_name, 20)} | #{pad(m['member_rating'], 13)} | #{pad(m['status'], 12)} | #{m['is_gmonkey']}"
      end
    end
  end

  private

  def pad(value, padding, max_length=25)
    value = value.to_s
    "#{value[0..max_length]}#{' '*(padding - value[0..max_length].size)}"
  end

  def find_max(a, b)
    a > b ? a : b
  end

  def debug(results)
    puts "#{'*'*50}"
    puts results
    puts results.class
    puts "#{'*'*50}"
  end


  def show_member(m)
    puts "#{m['id']} - #{m['email']}: Rating=#{m['member_rating']}, List=#{m['list_name']}, VIP?=#{m['is_gmonkey']}"
  end

  def redirect_output?(results, options={})
    if @options[:output]
      case @options[:output].to_sym
      when :table
        as_table results, options
        exit_now!('')
      when :formatted
        as_formatted results, options
        exit_now!('')
      when :raw
        as_raw results
        exit_now!('')
      when :awesome, :hash
        ap results
        exit_now!('')
      end
    end
  end
end

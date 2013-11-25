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

  def member_search(results)
    redirect_output?(results)

    if results['exact_matches']['total'].to_i == 0 and results['full_search']['total'].to_i == 0
      exit_now!("No matches found.")
    end

    members = []

    if results['exact_matches']['total'].to_i > 0
      puts "#{'='*20} Exact Matches (#{results['exact_matches']['total']}) #{'='*20}"

      results['exact_matches']['members'].each do |member|
        members << member
      end
    elsif results['full_search']['total'].to_i > 0
      puts "#{'='*26} Matches (#{results['full_search']['total']}) #{'='*26}"
      results['full_search']['members'].each do |member|
        members << member
      end
    end

    tp members, :email, :id, :list_name, :member_rating, :status, "VIP?" => {:display_method => :is_gmonkey}
  end

  private

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

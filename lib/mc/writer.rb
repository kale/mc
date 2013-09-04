require 'awesome_print'

class CommandLineWriter
  def initialize(options)
    @options = options
    puts "*** DEBUG ON ***" if @options[:debug]
  end

  def standard(output, options={})
    case @options[:output].to_sym
    when :formatted
      formatted output, options
    when :raw
      puts output
    when :awesome
      ap output 
    end
  end

  def formatted(output, options={})
    # set default options
    options[:show_header] ||= true
    options[:show_index]  ||= false
    options[:debug]       ||= false

    fields = options[:fields]

    # find the correct staring level in the returned json
    if output.kind_of? Hash
      # array of hashes or just a single hash?
      if output["data"].nil?
        output = [output]
      else
        output = output["data"]
      end
    end

    if fields == :all
      fields = []
      output.first.each_key {|key| fields << key}
    end

    output.reverse! if options[:reverse]

    puts "Fields: #{[*fields].join(', ')}" unless fields.nil? || !options[:show_header]

    output.to_enum.with_index(1) do |item, index|
      if options[:debug] || fields.nil?
        puts "Number of items: #{output.count}"
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

        print "#{pad(index, output.count)} - " if options[:show_index]
        puts  "#{values_to_print.join(' ')}"
      end
    end
  end

  def search(output)
    i = output
    if i['exact_matches']['total'].to_i > 0
      puts "EXACT MATCHES (#{i['exact_matches']['total']})\n============="
      
      i['exact_matches']['members'].each do |member|
        show_member member
      end
    end

    if i['full_search']['total'].to_i > 0
      puts "FULL SEARCH (#{i['full_search']['total']})\n============="
      i['full_search']['members'].each do |member|
        show_member member
      end
    end

    rescue 
      puts output
  end

  private

  def debug(output)
    puts "#{'*'*50}"
    puts output
    puts output.class
    puts "#{'*'*50}"
  end


  def show_member(m)
    puts "#{m['id']} - #{m['email']}: Rating=#{m['member_rating']}, List=#{m['list_name']}, VIP?=#{m['is_gmonkey']}"
  end
end

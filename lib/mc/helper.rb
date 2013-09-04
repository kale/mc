module Helper
  def get_required_argument(name, option, global)
    return option unless option.nil?
    return global unless global.nil?
    help_now!("--#{name.to_s} is required")
  end

  def create_email_struct(emails)
    struct = []
    emails.split(',').each do |email|
      struct << {:email => email}
    end

    return struct
  end

  def not_implemented
    raise "This command is not implemented yet."
  end

  def view_to_print(global, fields, print_options=nil)
    if global[:raw]
      # only show the first field and nothing else
      return fields.first, {:show_index => false}
    else
      return fields, print_options
    end
  end

  def cli_print(input, fields=nil, options={})
    # set default options
    options[:show_header] ||= true
    options[:show_index]  ||= false
    options[:debug]       ||= false

    # find the correct staring level in the returned json
    if input.kind_of? Hash
      # array of hashes or just a single hash?
      if input["data"].nil?
        input = [input]
      else
        input = input["data"]
      end
    end

    if fields == :all
      fields = []
      input.first.each_key {|key| fields << key}
    end

    input.reverse! if options[:reverse]

    puts "Fields: #{[*fields].join(', ')}" unless fields.nil? || !options[:show_header]

    input.to_enum.with_index(1) do |item, index|
      if options[:debug] || fields.nil?
        puts "Number of items: #{input.count}"
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

        print "#{pad(index, input.count)} - " if options[:show_index]
        puts  "#{values_to_print.join(' ')}"
      end
    end
  end

  private

  def pad(num, total)
    padding = ""
    amount_to_pad = total.to_s.size - num.to_s.size
    amount_to_pad.times {padding << " "}
    padding + num.to_s
  end
end

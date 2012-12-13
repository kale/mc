module Helper
  def get_required_argument(name, option, global)
    return option unless option.nil?
    return global unless global.nil?
    help_now!("--#{name.to_s} is required")
  end

  def not_implemented
    exit
  end
    
  def cli_print(input, fields=nil, options={})
    # set default options
    options[:show_header] ||= true
    options[:show_index]  ||= true
    options[:debug]       ||= false

    # find the correct staring level in the returned json
    if input.kind_of? Hash
      input = input["data"] unless input["data"].nil?
    end
    
    if fields == :all
      fields = []
      input.first.each_key {|key| fields << key}
    end


    puts "Fields: #{[*fields].join(', ')}" unless fields.nil? || !options[:show_header]

    input.to_enum.with_index(1) do |item, index|
      if options[:debug] || fields.nil?
        puts "Number of items: #{input.count}"
        puts "Fields:"
        item.each {|k,v| puts "#{k} = #{v}"}
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
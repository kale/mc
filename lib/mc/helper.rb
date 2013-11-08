module Helper
  def na(item)
    if item.nil?
      return "NA"
    elsif item.is_a? Float
      '%.2f' % item
    else
      item
    end
  end

  def get_required_argument(name, option, global)
    return option unless option.nil?
    return global unless global.nil?
    help_now!("--#{name.to_s} is required")
  end

  def required_option(name, *options)
    options.each {|o| return o unless o.nil? or o.empty?}
    exit_now!("Error: --#{name.to_s} is required")
  end

  def required_argument(msg, *arguments)
    arguments.each {|a| return a unless a.nil? or a.empty?}
    exit_now!(msg)
  end

  def get_last_campaign_id
    @mailchimp_cached.campaigns_list(:limit => 1, :sort_field => "create_time")["data"].first["id"]
  end

  def create_email_struct(emails)
    struct = []
    emails.each do |email|
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

  def successful? status
    status['success_count'] > 0
  end

  def show_errors status
    if status['error_count'] > 0
      puts "Oops, had #{status['error_count']} error(s):"
      status['errors'].each do |error|
        # remove periods just to make the error look nicer
        puts "  #{error['error'].gsub('.','')} - #{error['email']['email']}"
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

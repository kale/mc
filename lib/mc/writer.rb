class CommandLineWriter
  def initialize(*options)
    @options = options.first
    puts "*** DEBUG ON ***" if @options[:debug]
  end

  def debug(output)
    puts "#{'*'*50}"
    puts output
    puts "#{'*'*50}"
  end

  def search_results(output)
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
  end

  private

  def show_member(m)
    puts "#{m['id']} - #{m['email']}: Rating=#{m['member_rating']}, List=#{m['list_name']}, VIP?=#{m['is_gmonkey']}"
  end
end

desc 'Golden Monkeys'
command [:goldenmonkey, :gm] do |c|

  c.desc 'Email Address to add/remove'
  c.flag :email

  c.desc 'List ID'
  c.flag :id

  c.desc 'Show all Activity (opens/clicks) for Golden Monkeys over the past 10 days'
  c.command :activity do |s|
    s.action do
      cli_print @mailchimp.gmonkey_activity, [:email, :action, :title, :timestamp], :reverse => true
    end
  end

  c.desc 'Add Golden Monkey(s)'
  c.command :add do |s|
    s.action do |global,options,args|
      @mailchimp.gmonkey_add(:id => options[:id], :email_address => options[:email])
    end
  end

  c.desc 'Remove Golden Monkey(s)'
  c.command :remove do |s|
    s.action do |global,options,args|
      status = @mailchimp.gmonkey_del(:id => options[:id], :email_address => options[:email])
      #TODO: create helper method to display success
      status["success"] > 0 ? "#{options[:email]} removed!" : "Oops!"
    end
  end

  c.desc 'List all Golden Monkeys'
  c.command :members do |s|
    s.action do
      cli_print @mailchimp.gmonkey_members, [:index, :email, :list_name, :list_id]
    end
  end
end

desc 'Golden Monkeys'
command [:goldenmonkey, :gm] do |c|

  c.desc 'Email Address to add/remove'
  c.flag [:email]

  c.desc 'Show all Activity (opens/clicks) for Golden Monkeys over the past 10 days'
  c.command :show do |s|
    s.action do
      puts @mailchimp.gmonkey_activity
    end
  end

  c.desc 'Add Golden Monkey(s)'
  c.command :add do |s|
    s.action do |global,options,args|
      @mailchimp.gmonkey_add(email)
    end
  end

  c.desc 'Remove Golden Monkey(s)'
  c.command :remove do |s|
    s.action do |global,options,args|
      @mailchimp.gmonkey_remove(email)
    end
  end

  c.desc 'List all Golden Monkey(s)'
  c.command :list do |s|
    s.action do
      cli_print @mailchimp.gmonkey_members, [:index, :email]
    end
  end
end
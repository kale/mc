desc 'Golden Monkeys'
command :goldenmonkey do |c|

  c.desc 'Email Address to add/remove'
  c.arg_name 'email'
  c.flag [:email]

  c.desc 'Show all Activity (opens/clicks) for Golden Monkeys over the past 10 days'
  c.command :show do |show|
    show.action do
      puts @mailchimp.gmonkey_activity
    end
  end

  c.desc 'Add Golden Monkey(s)'
  c.command :add do |add|
    add.action do |global,options,args|
      @mailchimp.gmonkey_add(email)
    end
  end

  c.desc 'Remove Golden Monkey(s)'
  c.command :remove do |remove|
    remove.action do |global,options,args|
      @mailchimp.gmonkey_remove(email)
    end
  end

  c.desc 'List all Golden Monkey(s)'
  c.command :list do |list|
    list.action do
      list @mailchimp.gmonkey_members, [:index, :email]#, :debug => true
    end
  end
end
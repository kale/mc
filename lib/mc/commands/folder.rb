desc 'Folder related funtions'
command :folder do |c|
  c.desc 'List all the folders for a user account'
  c.command :folders do |apikey|
    apikey.action do |global,options,args|
      cli_print @mailchimp.folders, [:name, :type]
    end
  end
end
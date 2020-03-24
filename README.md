# mc - Mailchimp from the command-line
With your Mailchimp [api key](http://admin.mailchimp.com/account/api) and this gem, you can access a lot of the functionality that you can do through the Mailchimp web interface, but all from the command-line. It uses a command/sub-command approach that allows you to quickly find the command you need.

Caching is setup so that you can run the command multiple times without worrying about hitting the Mailchimp servers. Caching is based on the api call + parameters used and expires in 24 hours. You can fetch new values by using the --skipcache global option.

## Install
```sh
    gem install mc
```

## Usage
To see all the commands you can run:
```
    mc --help
```
or just:

```
    mc
```


You should see something similar to:

    NAME
      mc - Command line interface to Mailchimp. Eep eep!

    SYNOPSIS
      mc [global options] command [command options] [arguments...]

    GLOBAL OPTIONS
      --apikey=apikey     - Mailchimp API Key (default: none)
      --debug             - Turn on debugging
      --help              - Show this message
      --list=listID       - List to use (default: none)
      --output, -o format - formatted, raw, or awesome (default: none)
      --skipcache         - Do not use cached result
      --version           - Display the program version

    COMMANDS
      campaigns  - Campaign related tasks
      ecomm      - Ecomm related actions
      export     - Export list, ecomm, or activity streams (no caching)
      gallery    - Manage images and documents that are in your account
      help       - Shows a list of commands or help for one command
      helper     - Basic admin funtions
      initconfig - Initialize the config file using current global options
      lists      - View information about lists and subscribers
      reports    - View various campaign level reporting
      search     - Search campaigns and members
      templates  - Manage templates within your account
      users      - Manage and invite Mailchimp user accounts
      vips       - Check activity and add/remove/list members


You can get details on specific subcommands by:

```
    mc help list
```

## With Great Power
With this tool you'll be able to access your account in ways that will bypass confirmations and limits that you'll find within the regular Mailchimp web application. So for example, you can unsubscribe users and send campaigns without any confirmation using the correct command and parameters. Caching, as mentioned above, is setup to avoid hitting your account too much, but care still needs to be taken. Lastly, before using this tool it is highly recommended that you read the [Mailchimp Getting Started Guide](https://mailchimp.com/developer/guides/get-started-with-mailchimp-api-3/).

## Want Updates?

Of course this repo has to have an associated Mailchimp list (only used to update you on new version releases): http://eepurl.com/K8Vcj

## Config File
To create a config file at ~/.mailchimp you can run:

	mc initconfig

You can then edit that file and include any defaults you want to set. I would highly recommend at a minimal including the api key and a default list:

	:apikey: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-usx
	:list: xxxxxxxxxx

> Note: once you get your api key you can get the list id by running 'mc lists list'.

## Todo
* Finish supporting all api calls
* Command-line tab auto-completion
* Better descriptions and help
* Complete testing coverage

## License
See license.txt file.

## Thanks
 * Amro for the easy to use [gibbon](https://github.com/amro/gibbon) gem
 * David Copeland's [gli](https://github.com/davetron5000/gli) command-line gem
 * And of course Mailchimp and their sweet API

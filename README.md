# mc - MailChimp from the command-line

With your MailChimp [api key](http://admin.mailchimp.com/account/api) and this gem, you can access a lot of the functionality that you can get through the MailChimp web interface.


## Install
```sh
    gem install mc
```

## Usage

To see all the commands you can run:
```sh
	mc --help or just mc
```

You should see:

	NAME
	    mc - Command line interface to MailChimp. Eep eep!

	SYNOPSIS
	    mc [global options] command [command options] [arguments...]

	VERSION
	    0.0.1

	GLOBAL OPTIONS
	    --apikey=apikey       - MailChimp API Key (default: none)
	    --debug               - Turn on debugging
	    --default_list=listID - Default list to use (default: none)
	    --help                - Show this message
	    --resetcache          - Do not use cached result
	    --version 

	COMMANDS
	    api              - API/Security related commands
	    campaign         - Campaign related tasks
	    folder           - Folder related funtions
	    goldenmonkey, gm - Golden Monkeys
	    help             - Shows a list of commands or help for one command
	    helper           - Basic admin funtions
	    initconfig       - Initialize the config file using current global options
	    list             - View information about lists and subscribers

You can get details on specific subcommands by:

	mc help list


## Config File

To create a config file at ~/.mailchimp you can run:

	mc initconfig

You can then edit that file and include any defaults you want to set. I would highly recommend at a minimal including the api key and a default list:

 	:apikey: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-usx
	:default_list: xxxxxxxxxx

> Note: once you get your api key you can get the list id by running 'mc list lists'.

## Todo

* Currently focused on creating more subcommands
* Command-line tab auto-completion
* Addition descriptions and help
* Complete testing coverage

## Thanks

* [MailChimp](http://mailchimp.com) for having a sweet API
* Amro Mousa who maintains [Gibbon](https://github.com/amro/gibbon), the Ruby wrapper for the MailChimp API

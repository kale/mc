Feature: The mc app has a useful user interface
  As a user of the mc application
  It should have a nice UI, since it's GLI-powered

  Scenario: App just runs
    When I get help for "mc"
    Then the exit status should be 0

  Scenario: Shows default global options
    When I run `mc`
    Then the output should contain "--apikey=apikey"

  Scenario: Shows that api key is required if not supplied
    When I run `mc helper ping` without a key or config file
    Then the output should contain "Must include MailChimp API key either via --apikey flag or config file."

  Scenario: Shows subcommand help
    When I run `mc helper`
    Then the output should contain "Command 'helper' requires a subcommand"

  Scenario: Shows a successful ping
    When I run `mc helper ping`
    Then the output should contain "Everything's Chimpy!"   

  Scenario: Shows apikey
    When I run `mc helper apikey`
    Then the output should match /\w{32}-us\d.*/
    Then the exit status should be 0

Feature: Send an email
  Scenario: Send an email
    Given I go to the inbox
    And I press the send email button
    When I fill in the to field with "example@example.com"
    And I fill in the subject with "Hello"
    And I write something for the email
    And I press send
    Then my email should be sent
    And I should not see the email form
    And I should see a banner prompting me to add tasks about the email

  Scenario: User wants to CC/BCC people
    Given I'm sending an email
    And CC and BCC are hidden
    When I press the CC button
    Then the CC field should show
    And I should not see the CC button
    When I press the BCC button
    Then the BCC field should show
    And I should see the BCC field

  Scenario: User want's a reminder for this email
    Given I'm sending an email
    When I press the check for response button
    Then I should see a switch to turn the reminder on/off
    And the switch should be on
    And I set in how many days to send the reminder
    When I press the done button
    Then I form should be hidden
    When I press the check for response button
    And I switch the reminder off
    Then I should not be able to change the reminder's time

  Scenario: User adds a signature, but doesn't have one
    Given I'm sending an email
    But I haven't set my default signature
    When I write something in the email
    And I press the add signature button
    Then I should see a modal with a default signature
    And the default includes my name
    And the default includes my company and job title
    And the default includes my email & phone number
    And I write my own signature in the box
    When I press the done button
    Then I the modal should go away
    And the email should have my signature at the bottom
    And I should be able to type where I left off
    And I should not see the add signature button

  Scenario: User adds their default signature
    Given I'm sending an email
    And I've saved my signature
    When I write something in the email
    And I press the add signature button
    Then the email should have my signature at the bottom
    And I should able to type where I left off
    And I should not see the add signature button

  Scenario: User types a peron's name
    Given I'm sending an email
    And Paul is a user
    When I type "Paul" into the autocomplete
    And I press enter or type a comma
    Then Paul should be selected

  Scenario: User types a peron's email
    Given I'm sending an email
    And Paul is a user
    And Paul's email is paul@radiumcrm.com
    When I type "paul@radiucmrm.com" into the autocomplete
    And I press enter or type a comma
    Then "Paul" should be selected

  Scenario: User types an unknown email
    Given I'm sending an email
    And my address book is empty
    When I type "newperson@xample.com"
    And I press enter or type a comma
    Then "newperson@example.com" should be shown

  Scenario: User types part of a name
    Given I'm sending an email
    And Paul is a user
    When I type "Pa" into the autocomplete
    And I press enter or type a comma
    Then "Paul" should be selected

  Scenario: User types part of an email
    Given I'm sending an email
    And Paul is a user
    And Paul's email is "cowan@radiumcrm.com"
    When I type "cowan" into the autocomplete
    And I press enter or type a comma
    Then "Paul" should be selected

  Scenario: User sends a blank email
    Given I'm sending an email
    And Paul is another user
    And I send the email to paul
    And I leave the subject and email blank
    When I press send
    Then I should see a modal asking me to confirm I want to send a blank email
    When I accept
    Then the modal should go away
    And my email should be sent

  Scenario: User doesn't fill in the to field
    Given I'm sending an email
    But I don't send it to anyone
    When I press send
    Then I should see a validation problem

Feature: Deleting Messages on the Inbox
  Messages refer to emails and discussion

  Scenario: Delete the selected message
    Given I go to the inbox
    And a message is selected in the sidebar
    When I delete the message
    Then the next message should be selected
    And I should see the next message

  Scenario: Delete an unselected message
    Given I go the inbox
    When I delete an unselected message
    Then my selection shouldn't change
    And I should see the same email

  Scenario: Delete an email from the main view
    Given I have some emails
    And I go to the inbox
    And I select one of my emails
    When I delete the email form the main view
    Then I shouldn't see the email
    And the next message should be selected

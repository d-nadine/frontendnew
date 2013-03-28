Feature: Inbox
  Background:
    Given I have an account

  Scenario: User visits the inbox
    Given I login
    When I go to the inbox
    Then I should see my emails and discussions
    And I should see the first message

  Scenario: User views their sent messages
    Given I login
    And I have some sent emails
    When I go to the inbox
    And I open the folder drawer
    And I select the "Sent"
    Then I should see the emails I've sent
    And I should see the first message

  Scenario: User views their discussions
    Given I login
    And I'm participating in some discussions
    When I go to the inbox
    And I open the folder drawer
    And I select "Discussions"
    Then I should see the discussions I'm in
    And I should see the first discussion

  Scenario: User views all thier messages
    Given I login
    And I'm participating in some discussions
    And I've sent some emails
    And I've received some emails
    When I go to the inbox
    And I open the folder drawer
    And I select "All"
    Then I should see the discussions I'm in
    And I should see the emails I've sent
    And I should see the emails I've recieved

  Scenario: There's tasks about an email
    Given I have an email
    And there's a task associated with that email
    When I login
    And I go to the inbox
    Then I should see the email
    And there should be a task indicator

  Scenario: There's tasks about a discussion
    Given I'm participating in a discussion
    And there's a task associated with that discussion
    When I login
    And I go to the inbox
    Then I should see the discussion
    And there should be a task indicator

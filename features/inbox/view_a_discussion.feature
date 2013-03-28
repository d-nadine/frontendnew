Feature: View a Discussion on the Inbox
  Scenario: User views a discussion
    Given I'm participating in a discussion
    When I go to the discussion
    Then the discussion should be selected
    Then I should see all the people having it
    And I should see the content
    And I should see what the discussion is about
    And I should see the related tasks
    And I should see the attachments
    And I should see the comments
    And there should be a button to add a task

  Scenario: View a deal discussion
    Given Bob is a contact
    Given there's an Imacs deal with Bob
    Given I'm participating is a discussion about Imacs
    When I go to the discussion
    Then I should see the Imacs
    And I should see Bob's information in the HUD
    And I should see the deals' info in the HUD
    And I should see the deal's next task in the HUD

  Scenario: View a contact discussion
    Given Bob is a contact
    Given I'm participating is a discussion about Bob
    When I go to the discussion
    Then I should see Bob
    And I should see Bob's information in the HUD
    And I should see Bob's current deal in the HUD
    And I should see the next task about Bob in the HUD

  Scenario: Add a todo about a deal discussion
    Given there's an Imacs deal
    And I'm particpating in a discussion about Imacs
    When I go to the discussion
    And I make a todo about the discussion
    Then I should see the todo under the discussion's related tasks
    When I go the the Imacs deal page
    Then I should see the todo 
    And the discussion should be mentioned with the todo

  Scenario: Add a call about a deal discussion
    Given Bob is a contact
    And I made an deal for Imacs with Bob
    And I have a discussion about the deal
    When I go to the discussion
    And I make a call about the discussion
    Then I should see a call to Bob under the discussion's related tasks
    When I go to Bob's page
    Then I should see the call
    And the discussion should be mentioned with the call

  Scenario: Add a meeting about a deal discussion
    Given Bob is a contact
    And I made a deal for Imacs with Bob
    Given Paul and Sami are other users
    And Paul, Sami, and I are having a discussion about the Imacs deal
    When I go to the discussion
    And I make a meeting about the discussion
    Then Paul, Sami, and Bob should be invited
    And I should see the meeting under the discussion's related tasks
    When I go to Bob's page
    Then I should see the meeting
    And the discussion should be mentioned with the meeting

  Scenario: Add a todo about a contact discussion
    Given Bob is a contact
    And there's a discussion about Bob
    When I go to the discussion
    And I make a todo about the discussion
    Then I should see the todo under the discussion's related tasks
    When I go to Bob's page
    Then I should see the todo
    And the discussion should be mentioned with the todo

  Scenario: Add a todo about a contact discussion
    Given Bob is a contact
    And there's a discussion about Bob
    When I go to the discussion
    And I make a call about the discussion
    Then I should see a call to Bob under the discussion's related tasks
    When I go to Bob's page
    Then I should see the call
    And the discussion should be mentioned with the call

  Scenario: Add a meeting about a contact discussion
    Given Bob is a contact
    And Paul and Sami are other users
    And Paul, Sami, and I are having a discussion about Bob
    When I go to the discussion
    And I make a meeting about the discussion
    Then Paul, Sami, Bob, and I should be invited
    And I should see the meeting under the discussion's related tasks
    When I go to Paul, Sami, Bob or I's page
    Then I should see the meeting
    And the discussion should be mentioned with the meeting

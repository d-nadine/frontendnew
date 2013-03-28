Feature: View an Email on the Inbox
  Scenario: User Views an email
    Given I login
    And Bob is a contact
    And I've received an email from Bob
    When I go to the inbox
    Then the email should be selected
    And I should see the email
    Then I should see who it's from
    And I should see the subject
    And I should see the message
    And I should see the attachments
    And I should see the related tasks
    And I should see if the email is tracked
    And I should see a button to reply
    And I should see a button to forward it
    And I should see a button to delete it
    And I should see the comments
    And there should be a button to show more info about the email
    And I should see a button to add a task
    Then I should see all the emails between Bob and I
    When I click open the email's info
    Then I should see everyone who received it
    And I should see everyone who was cc'd
    And I should see when it was sent
    And I should see who to reply to

  Scenario: Switch an email's tracking
    Given there's a contact named Bob
    And Bob is tracked in radium
    And Bob sends me an email
    And there's a user named Jack
    And I login
    When I go to Bob's email
    Then I should see the email is tracked
    When Jack logs in
    Then Jack should see Bob's email
    When I switch the email to untracked
    Then only I should see Bob's email

  Scenario: HUD for an email sent to a contact
    Given Bob is a contact
    And I sent an email to Bob
    When I go to the email
    Then I should see Bob's information in the HUD
    And I should see Bob's current deal in the HUD
    And I should see Bob's next task in the HUD

  Scenario: HUD for an email received from a contact
    Given Bob is a contact
    And I received an email from Bob
    When I go to the email
    Then I should see Bob's information in the HUD
    And I should see Bob's current deal in the HUD
    And I should see Bob's next task in the HUD

  Scenario: HUD for inter-company emails
    Given I've recieved an email from another user
    When I go to the email
    Then I should not see the HUD

  Scenario: Make a todo about an email with a contact
    Given Bob is a contact
    And I have an email with Bob
    When I go to the email
    And I make a todo about the email
    Then I should see the todo under the email's related tasks
    When I go to Bob's page
    Then I should see the todo

  Scenario: Make a todo about an email with multiple contacts
    Given Bob and Jane are contacts
    And I have an email sent to Bob and Jane.
    When I go to the email
    And I make a todo about the email
    Then I should see the todo under the email's related tasks
    When I go to Bob's page
    Then I should see the todo
    When I go to Jane's page
    Then I should see the todo

  Scenario: Make a todo about an inter-company email
    Given Paul is another user
    And Paul sends me an email
    When I go to the email
    And I make a todo about the email
    Then I should see the todo under the email's related tasks
    Then I don't know what happens next

  Scenario: Make a call about an email
    Given Bob is a contact
    And I have an email with Bob
    When I go to the email
    And I make a call about the email
    Then I should see a call to Bob under the email's related tasks
    When I go to Bob's page
    Then I should see the call

  Scenario: Make a call about an email sent to multiple contacts
    Given Bob and Jane are contacts
    And I sent an email to Bob and Jane
    When I go to the email
    And I make a call about the email
    And I select Jane for who to call
    Then I should see a call to Jane under the email's related tasks
    When I go to Janes's page
    Then I should see the call

  Scenario: Add a meeting about an email
    Given Paul is another user
    And Bob is a contact
    And I sent an email to Paul and Bob
    When I go to the email
    And I make a meeting about the email
    Then Paul and Bob should be invited
    And I should see a meeting with Bob and Paul under the email's related tasks
    When I go to Paul's page
    Then I should see the meeting
    When I go to Bob's page
    Then I should see the meeting

  Scenario: Add a meeting about an email sent to multiple contacts
    Given Bob and Jane are contacts
    And I sent an email to Bob and Jane
    When I go to the email
    And I make a meeting about the email
    Then Bob and Jane should be invited
    And I should see a meeting with Bob and Jane under the email's related tasks
    When I go to Bob's page
    Then I should see the meeting
    When I go to Jane's page
    Then I should see the meeting

  Scenario: Add a deal to an email with a contact
    Given Bob is a contact
    And Bob sent me an email
    When I go to the email
    And I make a deal about the email
    Then I should be on the new deal page
    And the form should be prefilled with Bob's information
    And the email should be mentioned on the form

  Scenario: Add a deal to an email sent to multiple contacts
    Given Bob and Jane are contacts
    And I sent an email to Bob and Jane
    When I go to the email
    And I make a deal about the email
    Then I should be on the new deal page
    And I should have to choose who the deal is with
    And the email should be mentioned on the form

  Scenario: Add a deal about an inter-company email
    Given Paul is another user
    And Paul sent me an email
    When I go the email
    And I make deal about the email
    Then I should be on the new deal page
    And I should have to choose who the deal is with
    And the email should be mentioned on the form


  # should we be able to change to/cc/bcc/subject stuff
  # when replying?
  Scenario: Reply to an email
    Given Bob is a contact
    And Bob sent me an email about "Next week"
    And I go to the email
    And I click show details I can edit to/cc/bcc/subject
    And I add a CC to John Smith
    When I press the reply button
    Then I see only a place to type my response
    When I press send
    Then I should see a confirmation
    Then the form should go away
    And the reply should be at the top of the thread
    And the app should smooth scroll to the top
    Then Bob should receive a "RE: Next week" email

  # are people allowed to write part of the email
  # when forwarding?
  Scenario: Forward an email
    Given I have an email about "Next Week"
    And I go the email
    When I press the forward button
    Then I should see the to field
    And I type some people to forward it to
    And I type a note above the forwarded text
    And I press send
    Then I should see a confirmation
    And the form should go away
    Then they should recieve a "FWD: Next Week" email

  Scenario: User tries to forward an email to the person who sent it
    Given I have an email from Bob
    And I'm a noob
    And I go to the email
    When I press the forward button
    And I type Bob into forward field
    And I press send
    Then I should see a modal saying that's not allowed
    And I press OK
    Then Bob should be removed from the forward field

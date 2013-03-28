@review
Feature: Email Converation History
  A conversation is a list of messages between a group of
  people in reverse chronological order. Given an email (A),
  another email (B) can be considered part of the conversation
  if: 

    * A.sender is B.to
    * B.sender is A.to

  It's questionable how we handle things like CC, or what
  happens when an email is sent to multiple people.

  Background:
    Given Paul and Sami are other users
    And Bob and Jane are contacts

  Scenario: Simple past emails
    Given I sent Bob an "Email #1" email
    And Bob sent me an "Email #2" email
    When I go to "Email #2"
    Then I should see this conversation:
      | Email #1 |
      | Email #2 |

  Scenario: View an email in the middle of the conversation
    Given I sent Bob an "Email #1" email
    And Bob replied with "Email #2"
    And I replied with "Email #3"
    And Bob replied with "Email #4"
    When I go to "Email #3"
    Then I should see this converation:
      | Email #1 |
      | Email #2 |
      | Email #3 |
    And I should see a notice that there is a newer email

  Scenario: Inter-company email
    Given I sent "Email #1" to Paul
    And Paul replied back with "Email #2"
    And I sent "Email #3" to Sami and Paul
    And Sami replied with "Email #4"
    And Paul replied with "Email #5"
    And I replied to Sami with "Email #6"
    And I replied to Paul with "Email #7"
    When I go to "Email #7"
    Then I should see this conversation:
      | Email #1 |
      | Email #2 |
      | Email #3 |
      | Email #5 |
      | Email #7 |
    When Sami goes to "Email #6"
    Then ee should see this conversation: |
      | Email #3 |
      | Email #4 |
      | Email #6 |

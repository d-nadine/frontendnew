Feature: Add a Deal
  Scenario: User Submits a valid form
    Given Bob is a contact
    When I go to the new deal form
    And I fill in the name 
    And I choose Bob as the contact
    And I fill in the description
    And I fill in how much the deal is worth
    And I select the status
    Then the deal should be ready

  Scenario: A deal is added
    Given I go to the new deal form
    When I fill in the form
    And I press "Add Published Deal" or "Add Draft Deal"
    # Option 1
    Then I should see a success screen
    And I should be on the deal's page
    # Option 2
    Then I should see a success screen
    And I should be prompted to add tasks about the deal

  # How do we see draft deals?
  Scenario: Add a draft deal
    Given I go the new deal form
    When I fill in the form
    And I press "Add Draft Deal"
    Then the deal should not be listed in the pipeline

  Scenario: Add a published deal
    Given I go to the new deal form
    When I fill in the form
    And I press "Add Published Deal"
    Then the deal should be part of the pipeline

  Scenario: Add a Deal from a Lead
    Given Bob is a Contact
    And there's a lead with Bob
    When I go to the pipeline
    And add a deal about the lead
    Then the contact field should be prefilled with Bob

  Scenario: User changes the forecast
    Given the manager set this forecast:
      | had a call    | 15% |
      | had a meeting | 20% |
      | sent a qoute  | 15% |
    When I go the new deal form
    Then the forecast should be 0%
    When I check "had a call"
    Then the forecast should be 15%
    When I open the new forecast item form
    And I add this to forecast:
      | done | description   | precentage |
      |   x  | second call   | 5%         |
      |   x  | VP approval   | 25%        | 
    Then the forecast should be 55%

  Scenario: User is overconfident in their ability to close the deal
    Given the manager set this forecast:
      | had a call    | 15% |
      | had a meeting | 20% |
      | sent a qoute  | 15% |
    And I go to the new deal form
    When I go the new deal form
    Then the forecast should be 0%
    When I check "had a call"
    Then the forecast should be 15%
    When I add this to the forecast:
      | done | description                                   | precentage   |
      |   x  | This guy was my college roomate. It's a lock. | 100%         |
    Then the forecast should be 115%
    And the progess bar should be maxed out

  Scenario: User modifies the forecast
    Given the manager set this forecast:
      | had a call    | 15% |
      | had a meeting | 20% |
      | sent a qoute  | 15% |
    And I go to the new deal form
    When I go the new deal form
    And I change "had a call" to "30%" because "they had already reviewed our brochure"
    Then the forecast should be 30%

  Scenario: Fill in extra information
    Given I go to the new deal form
    When I press "Extra Information"
    Then I can fill in where the deal came from
    And I can add attachments
    And I can set the purchase order
    And I can add custom fields

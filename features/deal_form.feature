Feature: Add a Deal
  Scenario: Add a Deal from a Lead
    Given Bob is a Contact
    And there's a lead with Bob
    When I go to the pipeline
    And add a deal about the lead
    Then the contact field should be prefilled with Bob

  Scenario: User wants to complete Checklist
    Given I am adding a deal
    And the checklist is hidden
    When I press the show button
    Then the checklist should become visible
    And I should see a list of unchecked checklist iems
    And a weight for each item
    And a forecast of 0% done

  Scenario: User selects a checkbox item
    Given I am adding a deal
    And the checklist is visible
    When I select a checklist item
    Then the item is prefilled in the preview pane
    And I can finish the item in the preview pane

  Scenario: User wants to complete a Checklist item
    Given I am adding a deal
    And the checklist is shown
    When I check a Checklist item
    Then the weight of the Checklist item is highlighted
    And the forecast total increases by the selected weight
    And the finish button becomes an undo button

  Scenario: User wants to add an additional Checklist information
    Given I am adding a deal
    And the checklist is visible
    Then an additional checklist item is shown
    And I can add a weight
    And add a reason for that weight

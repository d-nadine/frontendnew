require "components/multiple_base_component"

Radium.PhoneNumbersComponent = Radium.MultipleBaseComponent.extend
  isEditing: false
  relationship: "phoneNumbers"

  phoneNumbers: Ember.A()

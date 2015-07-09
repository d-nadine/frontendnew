require "components/multiple_base_component"

Radium.EmailAddressesComponent = Radium.MultipleBaseComponent.extend
  isEditing: false
  relationship: "emailAddresses"

  emailAddresses: Ember.A()

  sortedEmailAddresses: Radium.computed.sortByPrimary 'model', 'emailAddresses'

  emailValidations: ['email']

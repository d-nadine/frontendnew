require "components/multiple_base_component"

Radium.EmailAddressesComponent = Radium.MultipleBaseComponent.extend
  tagName: 'dl'
  classNames: ['dl-horizontal', 'contact-types-list']

  isEditing: false
  relationship: "emailAddresses"

  emailAddresses: Ember.A()

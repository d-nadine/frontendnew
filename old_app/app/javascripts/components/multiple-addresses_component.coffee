require "components/multiple_base_component"
require "mixins/multiple_address_behaviour"

Radium.MultipleAddressesComponent = Radium.MultipleBaseComponent.extend  Radium.MultipleAddressBehaviour,
  isEditing: false
  relationship: "addresses"

  addresses: Ember.A()

  setModelFromHash: ->
    @setAddressFromHash @get('model'), @get('addresses'), @emailIsValid

  emailIsValid: (email) ->
    Radium.EMAIL_REGEX.test email

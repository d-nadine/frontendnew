require "components/multiple_base_component"

Radium.EmailAddressesComponent = Radium.MultipleBaseComponent.extend
  isEditing: false
  relationship: "emailAddresses"

  emailAddresses: Ember.A()

  sortedEmailAddresses: Ember.computed 'model.emailAddresses.[]', 'model.emailAddresses.@each.isPrimary', ->
    return Ember.A() unless @get('model.emailAddresses.length')

    @get('model.emailAddresses').toArray().sort (left, right) ->
      leftIsPrimary = left.get('isPrimary')
      rightIsPrimary = right.get('isPrimary')

      return -1 if leftIsPrimary
      return 1 if rightIsPrimary

      return 0

  emailValidations: ['email']

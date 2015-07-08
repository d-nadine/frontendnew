require "components/multiple_base_component"

Radium.PhoneNumbersComponent = Radium.MultipleBaseComponent.extend
  isEditing: false
  relationship: "phoneNumbers"

  phoneNumbers: Ember.A()


  sortedPhoneNumbers: Ember.computed 'model.phoneNumbers.[]', 'model.phoneNumbers.@each.isPrimary', ->
    return Ember.A() unless @get('model.phoneNumbers.length')

    @get('model.phoneNumbers').toArray().sort (left, right) ->
      leftIsPrimary = left.get('isPrimary')
      rightIsPrimary = right.get('isPrimary')

      return -1 if leftIsPrimary
      return 1 if rightIsPrimary

      return 0

  emailValidations: ['email']

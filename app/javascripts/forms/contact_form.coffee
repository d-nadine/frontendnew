require 'forms/form'

Radium.ContactForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    assignedTo: @get('assignedTo')
  ).property().volatile()

  isValid: ( ->
    return if Ember.isEmpty(@get('name'))
    return unless @get('emailAddresses').someProperty 'value'
    true
  ).property('name', 'emailAddresses.[]')



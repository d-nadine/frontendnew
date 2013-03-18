require 'forms/form'

Radium.ContactForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    assignedTo: @get('assignedTo')
    notes: @get('notes')
    source: @get('source')
    status: @get('status')
    phoneNumbers: Ember.A()
    emailAddresses: Ember.A()
    addresses: Ember.A()
  ).property().volatile()

  isValid: ( ->
    return if Ember.isEmpty(@get('name'))
    return unless @get('emailAddresses').someProperty 'value'
    true
  ).property('name', 'emailAddresses.[]')

  commit: (transitionTo) ->
    contact = Radium.Contact.createRecord @get('data')

    @get('phoneNumbers').forEach (phoneNumber) =>
      contact.get('phoneNumbers').addObject Radium.PhoneNumber.createRecord phoneNumber

    @get('emailAddresses').forEach (email) =>
      contact.get('emailAddresses').addObject Radium.EmailAddress.createRecord email

    @get('addresses').forEach (address) =>
      contact.get('addresses').addObject Radium.EmailAddress.createRecord address

    contact.one 'didCreate', ->
      transitionTo contact

    @get('store').commit()

  reset: ->
    @_super.apply this, arguments

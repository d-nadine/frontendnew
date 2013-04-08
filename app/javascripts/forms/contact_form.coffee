require 'forms/form'

Radium.ContactForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    company: @get('company')
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
    return false unless @get('emailAddresses').someProperty 'value'
    return if Ember.isEmpty(@get('company'))
    true
  ).property('name', 'emailAddresses.@each.value')

  commit:  ->
    contact = Radium.Contact.createRecord @get('data')

    @get('phoneNumbers').forEach (phoneNumber) =>
      contact.get('phoneNumbers').addObject Radium.PhoneNumber.createRecord phoneNumber

    @get('emailAddresses').forEach (email) =>
      contact.get('emailAddresses').addObject Radium.EmailAddress.createRecord email

    @get('addresses').forEach (address) =>
      contact.get('addresses').addObject Radium.EmailAddress.createRecord address

    @get('store').commit()

    contact

  reset: ->
    @_super.apply this, arguments
    @set 'name', ''
    @set 'notes', ''
    @set 'source', ''

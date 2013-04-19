require 'forms/form'

Radium.ContactForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    companyName: @get('companyName')
    assignedTo: @get('assignedTo')
    notes: @get('notes')
    source: @get('source')
    status: @get('status')
    phoneNumbers: Ember.A()
    emailAddresses: Ember.A()
    addresses: Ember.A()
  ).property().volatile()

  isValid: ( ->
    return if Ember.isEmpty(@get('name')) && Ember.isEmpty(@get('companyName'))
    return if Ember.isEmpty(@get('source'))
    return unless @get('assignedTo')
    true
  ).property('name', 'companyName', 'assignedTo', 'source')

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

  addressDefaults: ->
    street: ''
    city: ''
    state: ''
    zipcode: ''
    country: ''

  reset: ->
    @_super.apply this, arguments
    @set 'isNew', true
    @set 'name', ''
    @set 'notes', ''
    @set 'source', ''
    @set 'companyName', ''
    @set 'status', 'lead'
    @set('phoneNumbers', [
      Ember.Object.create({name: 'Mobile', value: '', isPrimary: true}),
      Ember.Object.create({name: 'Work', value: ''}),
      Ember.Object.create({name: 'Home', value: ''})
    ])
    @set('emailAddresses', [
      Ember.Object.create({name: 'Work', value: '', isPrimary: true}),
      Ember.Object.create({name: 'Home', value: ''}),
    ])
    @set('addresses', [
      Ember.Object.create({name: 'Office', value: Ember.Object.create(@addressDefaults()), isPrimary: true}),
      Ember.Object.create({name: 'Home', value:  Ember.Object.create(@addressDefaults())}),
    ])

require 'forms/form'

Radium.ContactForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    companyName: @get('companyName')
    user: @get('user')
    notes: @get('notes')
    source: @get('source')
    status: @get('status')
    phoneNumbers: Ember.A()
    emailAddresses: Ember.A()
    addresses: Ember.A()
    tags: Ember.A()
  ).property().volatile()

  isValid: ( ->
    return if Ember.isEmpty(@get('name')) && Ember.isEmpty(@get('companyName'))
    return if Ember.isEmpty(@get('source'))
    return unless @get('user')
    true
  ).property('name', 'companyName', 'user', 'source')

  create:  ->
    contact = Radium.CreateContact.createRecord @get('data')

    contact.set 'name', 'unknown contact' if Ember.isEmpty(contact.get('name'))

    # @get('phoneNumbers').forEach (phoneNumber) =>
    #   number = phoneNumber.get('value')
    #   if number.length && number != "+1"
    #     contact.get('phoneNumbers').push  phoneNumber.getProperties('name', 'value', 'isPrimary')

    # @get('emailAddresses').forEach (email) =>
    #   if email.get('value.length')
    #     contact.get('emailAddresses').push  email.getProperties('name', 'value', 'isPrimary')

    # @get('addresses').forEach (address) =>
    #   if @addressHasValue(address)
    #     contact.get('addresses').push address.getProperties('name', 'isPrimary', 'street', 'state', 'city', 'country', 'zipcode')

    @get('tags').forEach (tag) =>
      contact.get('tags').push tag.get('name')

    contact

  addressHasValue: (address) ->
    return true if address.get('street.length') > 1
    return true if address.get('state.length') > 1
    return true if address.get('city.length') > 1
    return true if address.get('zipcode.length') > 1

  reset: ->
    @_super.apply this, arguments
    @set 'isNew', true
    @set 'name', ''
    @set 'notes', ''
    @set 'source', 'From Website'
    @set 'companyName', ''
    @set 'company', ''
    @set 'status', 'lead'
    @set 'tags', Ember.A()
    @set 'tagNames', Ember.A()
    @set 'emailAddresses', Ember.A()
    @set 'phoneNumbers', Ember.A()
    @set 'addresses', Ember.A()

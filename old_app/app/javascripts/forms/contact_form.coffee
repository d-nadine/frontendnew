require 'forms/form'
require 'mixins/addresses_mixin'

Radium.ContactForm = Radium.Form.extend Radium.AddressesMixin,
  data: ( ->
    name: @get('name')
    companyName: @get('companyName')
    isPublic: true
    user: @get('user')
    about: @get('about')
    source: @get('source')
    contactStatus: @get('contactStatus')
    dealState: @get('dealState')
    phoneNumbers: Ember.A()
    emailAddresses: Ember.A()
    addresses: Ember.A()
    lists: Ember.A()
    website: @get('website')
    gender: @get('gender')
    fax: @get('fax')
    title: @get('title')
  ).property().volatile()

  isValid: Ember.computed 'name', 'companyName', 'user', 'source', ->
    return if Ember.isEmpty(@get('name')) && Ember.isEmpty(@get('companyName'))
    return if Ember.isEmpty(@get('source'))
    return unless @get('user')
    true

  create: ->
    data = @get('data')
    if status = data.contactStatus
      delete data.contactStatus
      data.contactStatus = Radium.ContactStatus.all().find (s) -> s.get('id') == status.get('id')

      Ember.assert "contact status was not found", data.contactStatus

    contact = Radium.CreateContact.createRecord data

    contact.set('companyName', null) if Ember.isEmpty(contact.get('companyName'))

    @get('phoneNumbers').forEach (phoneNumber) ->
      number = phoneNumber.get('value')
      if number.length && number != "+1"
        contact.get('phoneNumbers').push
          name: phoneNumber.get('name')
          number: phoneNumber.get('value')
          primary: phoneNumber.get('isPrimary')

    @get('emailAddresses').forEach (email) ->
      if email.get('value.length')
        contact.get('emailAddresses').push
          name: email.get('name')
          address: email.get('value')
          primary: email.get('isPrimary')

    @get('addresses').forEach (address) =>
      if @addressHasValue(address)
        contact.get('addresses').push address.getProperties('name', 'primary', 'street', 'line2', 'state', 'city', 'country', 'zipcode')

    @get('lists').forEach (list) ->
      contact.get('lists').push list.get('id')

    unless customFieldMap = @get('customFieldMap')
      return contact

    customFieldMap.forEach (key, field) ->
      if field.get('value.length')
        contact.get('customFieldValues').createRecord
          customField: key
          value: field.get('value')

    contact

  addressHasValue: (address) ->
    return true if address.get('street.length')
    return true if address.get('line2.length')
    return true if address.get('state.length')
    return true if address.get('city.length')
    return true if address.get('zipcode.length')
    return true if address.get('country.length')

  reset: ->
    @_super.apply this, arguments
    @set 'isNew', true
    @set 'name', ''
    @set 'about', ''
    @set 'source', null
    @set 'companyName', null
    @set 'company', ''
    @set 'dealState', @get('initialDealState')
    @set 'lists', Ember.A()
    @set 'isPublic', true
    @set 'emailAddresses', Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
    @set 'phoneNumbers', Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
    @set('addresses', @defaultAddresses())
    @set 'website', null
    @set 'gender', null
    @set 'fax', null
    @set 'twitter', null
    @set 'facebook', null
    @set 'linkedin', null
    @set 'title', null
    @set 'customFieldValues', Ember.A()
    @set 'contactStatus', null

    if customFields = @get('customFields')
      customFieldMap = Ember.Map.create()

      @get('customFields').forEach (field) ->
        customFieldMap.set field, Ember.Object.create(field: field, value: null)

      @set 'customFieldMap', customFieldMap

    leadSources = @get('leadSources')

    return unless leadSources?.length

    return unless leadSources.length

    initialLeadSource = if initialSource = leadSources.find((l) -> l.toLowerCase() == 'website')
                          initialSource
                        else
                           leadSources[0]

    @set 'source', initialLeadSource

require 'mixins/multiple_address_behaviour'

Radium.LeadsSingleController = Radium.Controller.extend Radium.FormArrayBehaviour,
  Radium.MultipleAddressBehaviour,
  Ember.Evented,
  actions:
    modelChanged: (model) ->
      @get('model').reset()
      @set 'form', null
      @set 'model', model

      if @get('contactCustomFields.length')
        customFieldMap = Ember.Map.create()

        @get('contactCustomFields').forEach (field) ->
          if contactsField = model.get('customFieldValues').find((f) -> f.get('customField') == field)
            value = contactsField.get('value')

          customFieldMap.set field, Ember.Object.create(field: field, value: value)

        model.set('customFieldMap', customFieldMap)

      @hashifyRelationships()

      @trigger 'modelChanged', model

      @clearContactCustomFields()

    clearExisting: ->
      @get('model').reset()
      form = @get('contactForm')
      form.reset()

      @set 'model', form
      @set 'emailAddresses', form.get('emailAddresses')
      @set 'phoneNumbers', form.get('phoneNumbers')
      @set 'addresses', form.get('addresses')

      @clearContactCustomFields()

      @set 'isSubmitted', false
      @set 'isSaving', false
      @trigger 'modelReset', form

    saveModel: (skipValidation) ->
      return @get('model').save() if skipValidation

      @set('isSubmitted', true)

      unless @get('isValid')
        return @send 'flashError', "You must supply a valid name or at least one valid email and select a valid user to assign this contact to."

      model = @get('model')
      isNew = model.get('isNew')

      if isNew && Ember.isEmpty(@get('model.companyName'))
        $('.modal').modal backdrop: false
        return

      customFieldMap = @get('model.customFieldMap') || Ember.A()

      if isNew
        model.set 'addresses', @get('addresses')
        @send 'saveNew'
      else
        @send 'saveExisting'

    saveExisting: ->
      model = @get('model')

      ['emailAddresses', 'phoneNumbers'].forEach (relationship) =>
        @setModelFromHash model, relationship, @get(relationship)

      @setAddressFromHash(model, @get('addresses'), @emailIsValid)

      model.get('customFieldMap').forEach (key, field) ->
        if existing = model.get('customFieldValues').find((f) -> f.get('customField') == key)
          existing.set('value', field.get('value'))
        else
          if field.get('value.length')
            model.get('customFieldValues').createRecord
              customField: key
              value: field.get('value')

      return unless model.get('isDirty')

      if Ember.isEmpty('companyName')
        model.set('removeCompany', true)

      model.save(this).then (result) =>
        @send 'flashSuccess', "#{model.get('displayName')} has been successfully updated."

        @hashifyRelationships()

    saveNew: ->
      $('.modal').modal 'hide' if $('.modal')

      model = @get('model')

      model.set('addresses', @get('addresses'))

      createContact = model.create()

      self = this

      createContact.save(this).then((result) =>
        Ember.run.next =>
          @set 'isSaving', false

          addressbookController = @get('controllers.addressbook')
          addressbookController.send('updateTotals') if addressbookController
          addressBook = @get('controllers.peopleIndex.model')
          contact = createContact.get('contact')
          addressBook.pushObject(contact)
          @transitionToRoute 'contact', createContact.get('contact')
        ).catch (error) =>
          @set 'isSaving', false

      @set 'isSaving', true

  hashifyRelationships: ->
    ['emailAddresses', 'phoneNumbers'].forEach (relationship) =>
      @set relationship, Ember.A()
      @createFormFromRelationship @get('model'), relationship, @get(relationship)

  clearContactCustomFields: ->
    @set('contactCustomFields', @get('contactCustomFields').slice())

  emailAddresses: Ember.A()
  phoneNumbers: Ember.A()

  addresses: Ember.A()
  needs: ['users', 'accountSettings', 'contactStatuses', 'addressbook', 'peopleIndex']

  contactCustomFields: []

  contactStatuses: Ember.computed 'controllers.contactStatuses.[]', ->
    @get('controllers.contactStatuses')

  isSaving: false
  isSubmitted: false
  errorMessages: Ember.A()

  isValid: Ember.computed 'isSubmitted', 'model.name', 'emailAddresses.@each.value', 'model.user', ->
    return true unless @get('isSubmitted')

    emailAddresses = @get('emailAddresses').mapProperty('value').reject (e) ->
      address = e || ''
      not $.trim(address).length

    name = $.trim(@get('model.name') || '')

    if emailAddresses.any((address) -> !Radium.EMAIL_REGEX.test(address))
      return false

    return false unless @get('model.user')

    if !name.length && !emailAddresses.get('length')
      return false

    true

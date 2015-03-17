Radium.LeadsSingleController = Radium.Controller.extend Radium.FormArrayBehaviour,
  Ember.Evented,
  actions:
    modelChanged: (model) ->
      @get('model').reset()
      @set 'form', null
      @set 'model', model
      ['emailAddresses', 'phoneNumbers'].forEach (relationship) =>
        @set relationship, Ember.A()
        @send 'createFormFromRelationship', model, relationship, @get(relationship)
      @trigger 'modelChanged', model

    clearExisting: ->
      @get('model').reset()
      form = @get('contactForm')
      form.reset()

      @set 'model', form
      @set 'emailAddresses', form.get('emailAddresses')
      @set 'phoneNumbers', form.get('phoneNumbers')
      @set 'addresses', form.get('addresses')

      @set 'isSubmitted', false
      @set 'isSaving', false
      @trigger 'modelReset', form

    saveModel: (skipValidation) ->
      return @get('model').save() if skipValidation

      @set('isSubmitted', true)

      unless @get('isValid')
        return @send 'flashError', "You must supply a valid name or at least one valid email "

      model = @get('model')

      if model.get('isNew') && Ember.isEmpty(@get('model.companyName'))
        $('.modal').modal backdrop: false
        return

      @send 'completeSubmit'

    completeSubmit: ->
      $('.modal').modal 'hide' if $('.modal')

      model = @get('model')

      createContact = model.create()

      isNew = model.get('isNew')

      self = this

      createContact.save(this).then((result) =>
        Ember.run.next =>
          @set 'isSaving', false

          if isNew
            addressbookController = @get('controllers.addressbook')
            addressbookController.send('updateTotals') if addressbookController
            addressBook = @get('controllers.peopleIndex.model')
            contact = createContact.get('contact')
            addressBook.pushObject(contact)
            @transitionToRoute 'contact', createContact.get('contact')
          else
            @send 'flashSuccess', 'contacts details have been updated.'
        ).catch (error) =>
          @set 'isSaving', false

      @set 'isSaving', true

  emailAddresses: Ember.A()
  phoneNumbers: Ember.A()
  addresses: Ember.A()
  needs: ['users', 'accountSettings', 'contactStatuses', 'addressbook', 'peopleIndex']
  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'
  isSaving: false
  isSubmitted: false
  errorMessages: Ember.A()

  isValid: Ember.computed 'isSubmitted', 'model.name', 'model.emailAddresses.@each.value', ->
    return true unless @get('isSubmitted')

    emailAddresses = @get('model.emailAddresses').mapProperty('value').reject (e) ->
      address = e || ''
      not $.trim(address).length

    name = $.trim(@get('model.name') || '')

    if emailAddresses.any((address) -> !Radium.EMAIL_REGEX.test(address))
      return false

    if !name.length && !emailAddresses.get('length')
      return false

    true

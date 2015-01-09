Radium.LeadsNewController= Radium.ObjectController.extend Radium.TrackContactMixin,
  Ember.Evented,
  actions:
    stopEditing: ->
      false

    addTag: (tag) ->
      return if @get('tagNames').mapProperty('name').contains tag

      @get('tagNames').addObject Ember.Object.create name: tag

    cancel: ->
      @get('form').reset()
      @set 'model', @get('form')

    submit: ->
      @set 'isSubmitted', true

      return unless @get('isValid')

      createContact = @get('model').create()

      @trigger 'hideModal'

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

  needs: ['contacts', 'users','companies', 'accountSettings', 'tags', 'countries', 'contactStatuses', 'addressbook', 'peopleIndex']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'
  leadSources: Ember.computed.alias 'controllers.accountSettings.leadSources'
  workflowStates: Ember.computed.alias 'controllers.accountSettings.workflowStates'
  form: null

  name: Ember.computed 'model.name', (key, value)->
    if arguments.length == 2 && @get('model').constructor isnt Radium.Contact
      @set('model.name', value)
    else
      return @get('model.name') if @get('model.name.length')

      @get('model.name') || @get('model.displayName')

  modelDidChange: Ember.observer 'model', ->
    return if @get('form') || !@get('model')

    @set 'form', @get('model') if @get('model.isNew')

  contactDeals: Ember.computed 'model', ->
    return if !@get('model') || @get('model.isNew')
    return unless @get('model.isPublic')

    # FIXME: Is there a better way?
    Radium.Deal.all().filter (deal) =>
      deal.get('status') != 'lost' && deal.get('contact') == @get('model')

  isNewTracked: Ember.computed 'model.isNew', 'status', ->
    @get('model.isNew') && @get('isPublic')

  trackedText: Ember.computed 'isPublic', ->
    if @get('isPublic') then "TRACKED" else "UNTRACKED"

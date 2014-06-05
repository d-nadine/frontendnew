Radium.LeadsNewController= Radium.ObjectController.extend Ember.Evented,
  actions:
    stopEditing: ->
      false

    addTag: (tag) ->
      return if @get('tagNames').mapProperty('name').contains tag

      @get('tagNames').addObject Ember.Object.create name: tag

    makeLead: ->
      @set 'status', 'pipeline'

      @get('store').commit()

    cancel: ->
      @get('form').reset()
      @set 'model', @get('form')

    submit: ->
      @set 'isSubmitted', true

      return unless @get('isValid')

      createContact = @get('model').create()

      @trigger 'hideModal'

      self = this

      # FIXME: should not have to call Ember.run.next
      createContact.one 'didCreate', =>
        Ember.run.next =>
          @set 'isSaving', false
          @transitionToRoute 'contact', createContact.get('contact')

      createContact.one 'becameError', (result) =>
        @set 'isSaving', false
        @send 'flashError', 'An error has occurred and the contact could not be created.'

      createContact.one 'becameInvalid', (result) =>
        @set 'isSaving', false
        @send 'flashError', createContact

      @set 'isSaving', true

      @get('store').commit()

  needs: ['contacts', 'users','companies', 'accountSettings', 'tags', 'countries', 'leadStatuses', 'addressbook']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  leadSources: Ember.computed.alias 'controllers.accountSettings.leadSources'
  workflowStates: Ember.computed.alias 'controllers.accountSettings.workflowStates'
  form: null

  name: Ember.computed 'model.name', (key, value)->
    if arguments.length == 2 && @get('model').constructor isnt Radium.Contact
      @set('model.name', value)
    else
      return @get('model.name') if @get('model.name.length')

      @get('model.name') || @get('model.displayName')

  modelDidChange: Ember.computed 'model', ->
    return if @get('form') || !@get('model')

    @set 'form', @get('model') if @get('model.isNew')

  contactDeals: Ember.computed 'model', ->
    return if !@get('model') || @get('model.isNew')
    return unless @get('model.isLead')

    # FIXME: Is there a better way?
    Radium.Deal.all().filter (deal) =>
      deal.get('status') != 'lost' && deal.get('contact') == @get('model')

  isNewLead: Ember.computed 'model.isNew', 'status', ->
    @get('model.isNew') && @get('status') == 'pipeline'

Radium.LeadsNewController= Radium.ObjectController.extend Ember.Evented,
  needs: ['contacts', 'users','companies', 'accountSettings', 'tags', 'countries', 'leadStatuses']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  leadSources: Ember.computed.alias 'controllers.accountSettings.leadSources'
  workflowStates: Ember.computed.alias 'controllers.accountSettings.workflowStates'
  form: null

  addTag: (tag) ->
    return if @get('tags').mapProperty('name').contains tag

    @get('tags').addObject Ember.Object.create name: tag

  makeLead: ->
    @set 'status', 'pipeline'

    @get('store').commit()

  modelDidChange: ( ->
    return if @get('form') || !@get('model')

    @set 'form', @get('model') if @get('model.isNew')
  ).observes('model')

  contactDeals: ( ->
    return if !@get('model') || @get('model.isNew')
    return unless @get('model.isLead')

    # FIXME: Is there a better way?
    Radium.Deal.all().filter (deal) =>
      deal.get('status') != 'lost' && deal.get('contact') == @get('model')
  ).property('model')

  isNewLead: ( ->
    @get('model.isNew') && @get('status') == 'pipeline'
  ).property('model.isNew', 'status')

  cancel: ->
    @get('form').reset()
    @set 'model', @get('form')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    createContact = @get('model').create()

    @trigger 'hideModal'

    # FIXME: should not have to call Ember.run.next
    createContact.one 'didCreate', =>
      Ember.run.next =>
        @transitionToRoute 'contact', createContact.get('contact')

    createContact.one 'becameError', (result) =>
      Radium.Utils.notifyError 'An error has occurred and the contact could not be created.'

    createContact.one 'becameInvalid', (result) =>
      Radium.Utils.generateErrorSummary createContact

    @get('store').commit()

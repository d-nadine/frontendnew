Radium.LeadsNewController= Radium.ObjectController.extend
  needs: ['contacts', 'users','companies', 'accountSettings', 'tags', 'countries', 'leadStatuses']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  leadSources: Ember.computed.alias 'controllers.accountSettings.leadSources'
  form: null

  makeLead: ->
    @set 'status', 'lead'

    @get('store').commit()

  modelDidChange: ( ->
    return if @get('form') || !@get('model')

    @set 'form', @get('model') if @get('model.isNew')
  ).observes('model')

  isCustomer: ( ->
    return false if @get('isSaving')
    return false if @get('isNew')

    status = @get('model.status')
    return false unless status

    status == "lead" || status == "existing"
  ).property('model.status', 'isNew')

  cancel: ->
    @get('form').reset()
    @set 'model', @get('form')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    createContact = @get('model').create()

    # FIXME: should not have to call Ember.run.next
    createContact.one 'didCreate', =>
      Ember.run.next =>
        @transitionToRoute 'contact', createContact.get('contact')

    @get('store').commit()

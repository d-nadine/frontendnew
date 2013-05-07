Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users','companies', 'leadStatuses', 'leadSources', 'tags']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  leadSources: Ember.computed.alias 'controllers.leadSources.leadSources'
  form: null

  makeLead: ->
    @set 'status', 'lead'

    @get('store').commit()

  companyTags: ( ->
    company = @get('controllers.companies').findProperty 'name', @get('companyName')

    company?.get('tags')
  ).property('companyName')

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

    contact = @get('model').create()

    contact.one 'didCreate', =>
      @transitionToRoute 'contact', contact

    @get('store').commit()

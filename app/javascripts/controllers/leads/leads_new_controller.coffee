Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users','companies', 'leadStatuses', 'leadSources']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  leadSources: Ember.computed.alias 'controllers.leadSources.leadSources'
  form: null
  existingDetailsShown: false

  companyNames: ( ->
    return unless @get('companies.length')

    @get('companies').mapProperty('name')
  ).property('companies.[]')

  modelDidChange: ( ->
    @set('companyName', @get('model.company.name')) if @get('model') && !@get('model.isNew')

    return if @get('form') || !@get('model')

    @set 'form', @get('model') if @get('model.isNew')
  ).observes('model')

  isCustomer: ( ->
    return false if @get('isNew')

    status = @get('model.status')
    return false unless status

    status == "lead" || status == "existing"
  ).property('model.status', 'isNew')

  cancel: ->
    @set 'model', @get('form')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @set 'justAdded', true

    Ember.run.later( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false

      if @get('isNew')
        contact = @get('model').commit (contact)
        @transitionToRoute 'contact', contact
      else
        @get('store').commit()
        @transitionToRoute 'contact', @get('model')
    ), 1200)

Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users','companies', 'leadStatuses', 'leadSources', 'groups']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  form: null

  makeLead: ->
    @set 'status', 'lead'
    @get('store').commit()

  companyNames: ( ->
    return unless @get('companies.length')

    @get('companies').mapProperty('name')
  ).property('companies.[]')

  companyName: ( (key, value) ->
    if arguments.length == 1
      if @get('isNew')
        @get('model.companyName')
      else
        @get('company.name')
    else
      @set('model.companyName', value)
      value
  ).property('companyName', 'isNew', 'model')

  modelDidChange: ( ->
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
    @get('form').reset()
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

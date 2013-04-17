Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users','companies', 'leadStatuses', 'leadSources']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  companies: Ember.computed.alias 'controllers.companies'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  leadSources: Ember.computed.alias 'controllers.leadSources.leadSources'
  showDetail: false
  form: null
  isNewContact: false
  showExisting: false
  existingDetailsShown: false

  companyNames: ( ->
    return unless @get('companies.length')

    @get('companies').mapProperty('name')
  ).property('companies.[]')

  changeExisting: ->
    @set 'model.status', 'lead'
    @set 'existingDetailsShown', false
    @set 'showExisting', true

  isExistingContact: ( ->
    return false unless @get('model')

    unless @get('model.isNew')
      @set 'isNewContact', false
      return true

    false
  ).property('model', 'isNewContact')

  modelDidChange: ( ->
    return if @get('form') || !@get('model')

    @set 'form', @get('model') if @get('model.isNew')
  ).observes('model')

  isCustomer: ( ->
    status = @get('model.status')
    return false unless status

    status == "lead" || status == "existing"
  ).property('model.status')

  toggleDetail: ->
    @toggleProperty 'showDetail'

  cancel: ->
    @set 'model', @get('form')
    @set 'isNewContact', true

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

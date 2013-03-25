Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users','leadStatuses']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  showDetail: false
  form: null
  isNewContact: false

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

      contact = @get('model').commit (contact)
      @transitionToRoute 'contact', contact
    ), 1200)

Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
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

  leadStatuses: [
    {name: "None", value: "none"}
    {name: "Lead", value: "lead"}
    {name: "Existing Customer", value: "existing"}
    {name: "Exclude From Pipeline", value: "exclude"}
  ]

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

      # FIXME: Highly controversial but it gets round the form objects
      # not being initialised like a controller.  We need to review this.
      @get('model').commit (contact) =>
        @transitionToRoute 'contact', contact
    ), 1200)

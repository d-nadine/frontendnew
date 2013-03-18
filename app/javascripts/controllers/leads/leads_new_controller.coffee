Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  showDetail: false
  assignedTo: null

  init: ->
    @_super.apply this, arguments
    @set 'assignedTo', @get('currentUser')

  toggleDetail: ->
    @toggleProperty 'showDetail'

  leadStatuses: [
    {name: "None", value: "none"}
    {name: "Lead", value: "lead"}
    {name: "Existing Customer", value: "existing"}
    {name: "Exclude From Pipeline", value: "exclude"}
  ]

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
        @transitionTo 'contact', contact
    ), 1200)

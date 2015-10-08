Radium.UserController = Radium.ObjectController.extend   Radium.SaveEmailMixin,
  actions:
    confirmDeletion: ->
      @set "showDeleteConfirmation", true

      false

    saveEmail: (form) ->
      @_super.call this, form, dontTransition: true

      false

  needs: ['users', 'contacts', 'companies', 'accountSettings', 'contactStatuses']
  loadedPages: [1]

  showDeleteConfirmation: false
  isEditing: false

  users: Ember.computed.oneWay 'controllers.users'

  userIsCurrentUser: Ember.computed 'model', 'currentUser', ->
    @get('model') == @get('currentUser')

  currentMonth: Ember.computed ->
    Ember.DateTime.create().toFormattedString('%B')

  canDelete: Ember.computed 'userIsCurrentUser', 'currentUser.isAdmin', ->
    !@get('userIsCurrentUser') && @get('currentUser.isAdmin')

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')
      noteForm: @get('noteForm')
      emailForm: @get('emailForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model') unless @get('model') == @get('currentUser')
    user: @get('currentUser')

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'deal', ->
    user: @get('currentUser')
    reference: @get('currentUser')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    topic: null
    location: ""
    isNew: true
    reference: @get('model')
    users: Ember.A()
    contacts: Em.A()
    startsAt: @get('now').advance(hour: 1)
    endsAt: @get('now').advance(hour: 2)
    invitations: Ember.A()

  emailForm: Radium.computed.newForm 'email'

  emailFormDefaults: Ember.computed 'contact', ->
    to: Ember.A()

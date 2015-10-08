Radium.BulkActionControllerMixin = Ember.Mixin.create Ember.Evented,
  actions:
    showForm: (form) ->
      @set 'activeForm', form

    checkAll: ->
      content = if @hasOwnProperty('visibleContent')
                  @get('visibleContent')
                else
                  @get('content')

      content.setEach 'isChecked', !@get('hasCheckedContent')

    cancelSendEmail: ->
      @set 'activeForm', null

    showEmail: ->
      form = @get('newEmail')
      form.reset()

      contacts = @get('checkedContent').filter((contact) ->
        contact instanceof Radium.Contact).toArray()

      form.get('to').pushObjects(contacts)

      @send 'showForm', 'email'

    toggleThumbnails: ->
      @toggleProperty('isThumbnailsVisible')
      false

    submit: (form) ->
      return unless form
      return unless form.get('isValid')

      @set 'justAdded', true

      Ember.run.later(( =>
        @set 'justAdded', false

        form.commit()
        form.reset()

        @trigger 'formReset'
      ), 1200)

  needs: ['users', 'accountSettings']
  users: Ember.computed.alias 'controllers.users'
  statuses: Ember.computed.alias('controllers.accountSettings.dealStates')
  assignToUser: null
  reassignTodo: null
  changedStatus: null
  statusTodo: null
  justAdded: false

  perPage: 7
  activeForm: null

  isThumbnailsVisible: true

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showAssignForm: Ember.computed.equal('activeForm', 'assign')
  showEmailForm: Ember.computed.equal('activeForm', 'email')
  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

  hasActiveForm: Ember.computed.notEmpty('activeForm')

  init: ->
    @_super.apply this, arguments
    @set 'assignToUser', @get('currentUser')

  isLost: Ember.computed 'changedStatus', ->
    return unless @get('changedStatus')
    @get('changedStatus').toLowerCase() == 'lost'

  activeStatuses: Ember.computed 'statuses.[]', 'title', ->
    @get('statuses').reject (status) => status.capitalize() == @get('title')

  clearChecked: ->
    @get('checkedContent').forEach (item) ->
      item.set('isChecked', false)

  reassignForm: Radium.computed.newForm('reassign')

  reassignFormDefaults: Ember.computed 'assignToUser', 'checkedContent.[]', 'reassignTodo', 'tomorrow', ->
    assignToUser: @get('assignToUser')
    selectedContent: @get('checkedContent')
    todo: @get('reassignTodo')
    finishBy: @get('tomorrow')

  todoForm: Radium.computed.newForm('todo')

  showFormArea: Ember.computed 'hasCheckedContent', 'hasActiveForm', ->
    @get('hasCheckedContent') && @get('hasActiveForm')

  todoFormDefaults: Ember.computed 'checkedContent.[]', 'tomorrow', ->
    description: null
    finishBy: null
    user: @get('currentUser')
    reference: @get('checkedContent')

  newEmail: Ember.computed ->
    Radium.EmailForm.create
      showAddresses: true
      showSubject: true
      showEmailCancel: true
      subject: ''
      message: ''
      to: []
      cc: []
      bcc: []
      files: Ember.A()
      attachedFiles: Ember.A()

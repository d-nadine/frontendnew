Radium.BulkActionControllerMixin = Ember.Mixin.create Ember.Evented,
  needs: ['users', 'dealStatuses', 'tags']
  users: Ember.computed.alias 'controllers.users'
  statuses: Ember.computed.alias('controllers.dealStatuses.inOrder')
  assignToUser: null
  reassignTodo: null
  changedStatus: null
  statusTodo: null
  justAdded: false

  perPage: 7
  activeForm: null

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showAssignForm: Ember.computed.equal('activeForm', 'assign')
  showChangeStatusForm: Ember.computed.equal('activeForm', 'status')
  showEmailForm: Ember.computed.equal('activeForm', 'email')
  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

  hasActiveForm: Ember.computed.notEmpty('activeForm')

  init: ->
    @_super.apply this, arguments
    @set 'assignToUser', @get('currentUser')

  changeStatus: ->
    @set 'changeStatusForm.todo', @get('statusTodo')
    @get('changeStatusForm').commit()
    @set('statusTodo', '')
    @trigger 'formReset'

  submit: (form) ->
    return unless form.get('isValid')

    @set 'justAdded', true

    Ember.run.later(( =>
      @set 'justAdded', false

      form.commit()
      form.reset()

      @trigger 'formReset'
    ), 1200)

  showForm: (form) ->
    @set 'activeForm', form

  changeStatusForm: Radium.computed.newForm('changeStatus')

  changeStatusFormDefaults: ( ->
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    deals: @get('checkedContent')
    finishBy: @get('tomorrow')
    status: @get('changedStatus')
    todo: @get('statusTodo')
  ).property('currentUser', 'checkedContent', 'statusTodo', 'tomorrow', 'status')

  reassignForm: Radium.computed.newForm('reassign')

  reassignFormDefaults: ( ->
    assignToUser: @get('assignToUser')
    selectedContent: @get('checkedContent')
    todo: @get('reassignTodo')
    finishBy: @get('tomorrow')
  ).property('assignToUser', 'checkedContent.[]', 'reassignTodo', 'tomorrow')

  todoForm: Radium.computed.newForm('todo')

  showFormArea: ( ->
    @get('hasCheckedContent') && @get('hasActiveForm')
  ).property('hasCheckedContent', 'hasActiveForm')

  todoFormDefaults: (->
    description: null
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('checkedContent')
  ).property('checkedContent.[]', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('model')
  ).property('model.[]', 'tomorrow')

  newEmail: (->
    Radium.EmailForm.create
      showAddresses: true
      showSubject: true
      showEmailCancel: true
      subject: ''
      message: ''
      to: []
      cc: []
      bcc: []
  ).property()

  checkAll: ->
    @get('visibleContent').setEach 'isChecked', !@get('hasCheckedContent')

  cancelSendEmail: ->
    @set 'activeForm', null

  showEmail: ->
    form = @get('newEmail')
    form.reset()

    contacts = @get('checkedContent').filter((contact) ->
      contact instanceof Radium.Contact).toArray()

    form.get('to').pushObjects(contacts)

    @showForm 'email'

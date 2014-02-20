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

    changeStatus: ->
      @set 'isSubmitted', true
      if @get('isLost')
        @set 'changeStatusForm.lostBecause', @get('lostBecause')

      return unless @get('changeStatusForm.isValid')
      @set 'changeStatusForm.todo', @get('statusTodo')
      @get('changeStatusForm').commit().then =>
        @send 'flashSuccess', "Deal's status succesfully changed"
        @set('statusTodo', '')
        @set 'isSubmitted', false
        @get('changeStatusForm').reset()
        @set 'lostBecause', ''
        @trigger 'formReset'
        , (error) =>
          @send 'flashError', error

    submit: (form) ->
      return unless form.get('isValid')

      @set 'justAdded', true

      Ember.run.later(( =>
        @set 'justAdded', false

        form.commit()
        form.reset()

        @trigger 'formReset'
      ), 1200)

  needs: ['users', 'accountSettings', 'tags', 'pipelineOpendeals']
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
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showAssignForm: Ember.computed.equal('activeForm', 'assign')
  showChangeStatusForm: Ember.computed.equal('activeForm', 'status')
  showEmailForm: Ember.computed.equal('activeForm', 'email')
  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

  hasActiveForm: Ember.computed.notEmpty('activeForm')

  init: ->
    @_super.apply this, arguments
    @set 'assignToUser', @get('currentUser')

  isLost: ( ->
    return unless @get('changedStatus')
    @get('changedStatus').toLowerCase() == 'lost'
  ).property('changedStatus')

  clearChecked: ->
    @get('checkedContent').forEach (item) =>
      item.set('isChecked', false)

  changeStatusForm: Radium.computed.newForm('changeStatus')

  changeStatusFormDefaults: ( ->
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    deals: @get('checkedContent')
    finishBy: @get('tomorrow')
    status: @get('changedStatus')
    todo: @get('statusTodo')
    lostBecause: @get('lostBecause')
  ).property('currentUser', 'checkedContent', 'statusTodo', 'tomorrow', 'status', 'lostBecause')

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
    reference: @get('checkedContent')
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
      files: Ember.A()
      attachedFiles: Ember.A()
  ).property()

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

    changeStatus: ->
      @set 'isSubmitted', true
      if @get('isLost')
        @set 'changeStatusForm.lostBecause', @get('lostBecause')

      diff = @get('checkedContent').reject (deal) =>
        deal.get('status') == @get('changedStatus')

      unless diff.length
        @send 'flashError', 'You need to specity a different deal status'
        return

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
      return unless form
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

  isLost: Ember.computed 'changedStatus', ->
    return unless @get('changedStatus')
    @get('changedStatus').toLowerCase() == 'lost'

  activeStatuses: Ember.computed 'statuses.[]', 'title', ->
    @get('statuses').reject (status) => status.capitalize() == @get('title')

  clearChecked: ->
    @get('checkedContent').forEach (item) =>
      item.set('isChecked', false)

  changeStatusForm: Radium.computed.newForm('changeStatus')

  changeStatusFormDefaults: Ember.computed 'currentUser', 'checkedContent', 'statusTodo', 'tomorrow', 'status', 'lostBecause', ->
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    deals: @get('checkedContent')
    status: @get('changedStatus')
    todo: @get('statusTodo')
    lostBecause: @get('lostBecause')

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
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('checkedContent')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: Ember.computed 'model.[]', 'tomorrow', ->
    description: null
    finishBy: @get('tomorrow')
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

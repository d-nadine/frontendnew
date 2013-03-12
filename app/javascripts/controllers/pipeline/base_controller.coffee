require 'forms/change_status'
require 'forms/reassign_form'

Radium.PipelineBaseController = Radium.ArrayController.extend Radium.ShowMoreMixin, Radium.CheckableMixin,
  needs: ['users']
  users: Ember.computed.alias 'controllers.users'
  statuses: Ember.computed.alias('controllers.dealStatuses.inOrder')
  reassignTodo: null
  changedStatus: null
  statusTodo: null
  justAdded: false

  perPage: 7
  activeForm: null

  showTodoForm: Radium.computed.equal('activeForm', 'todo')
  showCallForm: Radium.computed.equal('activeForm', 'call')
  showAssignForm: Radium.computed.equal('activeForm', 'assign')
  showChangeStatusForm: Radium.computed.equal('activeForm', 'status')

  hasActiveForm: Radium.computed.isPresent('activeForm')

  init: ->
    @_super.apply this, arguments
    @set 'assignToUser', @get('currentUser')

  changeStatus: ->
    @set 'changeStatusForm.statusTodo', @get('statusTodo')
    @submit @get('changeStatusForm')

  reassign: ->
    @submit @get('reassignForm')

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
    statusTodo: @get('statusTodo')
  ).property('currentUser', 'checkedContent', 'statusTodo', 'tomorrow', 'status')


  reassignForm: Radium.computed.newForm('reassign')

  reassignFormDefaults: ( ->
    assignToUser: @get('assignToUser')
    selectedContent: @get('checkedContent')
    reassignTodo: @get('reassignTodo')
    finishBy: @get('tomorrow')
  ).property('assignToUser', 'checkedContent', 'reassignTodo', 'tomorrow')

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

  deleteAll: ->
    # FIXME: ember-data errors, fake for now
    # @get('checkedContent').forEach (pipelineItem) ->
    #   pipelineItem.get('content').deleteRecord()

    # @get('store').commit()
    @get('content').setEach('isChecked', false)

    Radium.Utils.notify 'deleted!'

  deleteObject: (pipelineItem) ->
    # FIXME: ember-data errors, fake for now
    # pipelineItem.get('content').deleteRecord()
    # @get('store').commit()

    pipelineItem.set 'isChecked', false
    Radium.Utils.notify "deleted!"

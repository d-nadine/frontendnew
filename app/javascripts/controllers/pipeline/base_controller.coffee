require 'forms/change_status'
require 'forms/reassign_form'
require 'controllers/pipeline/pipeline_item_controller'

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

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showAssignForm: Ember.computed.equal('activeForm', 'assign')
  showChangeStatusForm: Ember.computed.equal('activeForm', 'status')
  showEmailForm: Ember.computed.equal('activeForm', 'email')

  hasActiveForm: Ember.computed.notEmpty('activeForm')

  init: ->
    @_super.apply this, arguments
    @set 'assignToUser', @get('currentUser')

  changeStatus: ->
    @set 'changeStatusForm.todo', @get('statusTodo')
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
    todo: @get('statusTodo')
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

  isLeads: ( ->
    @get('title') == 'Leads'
  ).property('title')

  deleteAll: ->
    checkedContent = @get('checkedContent').toArray()

    for i in [checkedContent.length-1..0] by -1
      checkedContent[i].deleteRecord()

    @get('store').commit()

    Radium.Utils.notify 'deleted!'

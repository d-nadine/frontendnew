require 'forms/form_box'

Radium.MessagesBulkActionsController = Radium.ArrayController.extend
  needs: ['users', 'messages']

  content: Ember.computed.oneWay 'controllers.messages.checkedContent'

  itemController: 'messagesBulkActionItem'

  formBox: Ember.computed 'todoForm', 'callForm', 'discussionForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      # disable for now
      # callForm: @get('callForm')
      discussionForm: @get('discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model.[]', 'tomorrow', ->
    description: null
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('model')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: Ember.computed 'model.[]', 'tomorrow', ->
    description: null
    contact: @get('contact')
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')

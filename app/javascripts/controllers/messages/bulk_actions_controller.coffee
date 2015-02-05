require 'forms/form_box'

Radium.MessagesBulkActionsController = Radium.ArrayController.extend
  needs: ['users', 'messages']

  model: Ember.computed.oneWay 'controllers.messages.checkedContent'

  canArchive: Ember.computed 'controllers.messages.folder', ->
    @get('controllers.messages.folder') != "archive"

  itemController: 'messagesBulkActionItem'

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model.[]', 'tomorrow', ->
    description: null
    finishBy: null
    user: @get('currentUser')
    reference: @get('model')

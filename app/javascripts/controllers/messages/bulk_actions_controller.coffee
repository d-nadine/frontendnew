Radium.MessagesBulkActionsController = Ember.ArrayController.extend
  needs: ['clock','users']
  clock: Ember.computed.alias('controllers.clock')

  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  itemController: 'messagesBulkActionItem'

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: (->
    Radium.TodoForm.create
      content: Ember.Object.create
        reference: @get('model')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
        reference: @get('model')
  ).property('model.[]', 'tomorrow')

  callForm: (->
    Radium.CallForm.create
      canChangeContact: false
      content: Ember.Object.create
        reference: @get('contact')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
        reference: @get('model')
  ).property('model.[]', 'tomorrow')

  cancel: ->
    # FIXME: No idea why this did not work if toArray was not used
    @get('model').toArray().forEach (item) ->
      item.set('isChecked', false)

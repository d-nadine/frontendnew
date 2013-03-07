Radium.MessagesBulkActionsController = Ember.ArrayController.extend Radium.CurrentUserMixin,
  needs: ['clock','users']
  clock: Ember.computed.alias('controllers.clock')

  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  itemController: 'messagesBulkActionItem'

  formBox: (->
    @set('callForm.canChangeContact', false) if @get('callForm')

    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('model')
  ).property('model.[]', 'tomorrow', 'currentUser')

  callForm: Radium.computed.newForm('call')

  callFormDefaults: (->
    description: null
    reference: @get('contact')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('model')
  ).property('model.[]', 'tomorrow')

  cancel: ->
    # FIXME: No idea why this did not work if toArray was not used
    @get('model').toArray().forEach (item) ->
      item.set('isChecked', false)

Radium.EmailItemController = Em.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')

  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  showActions: false
  showReply: false

  showActionSection: ->
    @toggleProperty 'showActions'

  showReplySection: ->
    @toggleProperty 'showReply'

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
  ).property('todoForm', 'callForm')

  todoForm: (->
    Radium.TodoForm.create
      content: Ember.Object.create
        reference: @get('model')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: (->
    Radium.CallForm.create
      canChangeContact: false
      content: Ember.Object.create
        finishBy: @get('tomorrow')
        user: @get('currentUser')
  ).property('model', 'tomorrow')

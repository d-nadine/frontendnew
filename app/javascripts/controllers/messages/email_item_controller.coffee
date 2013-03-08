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


  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: true)

  callFormDefaults: (->
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

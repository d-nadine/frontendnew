Radium.EmailsItemController = Radium.ObjectController.extend
  clock: Ember.computed.alias('controllers.clock')

  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  showMeta : false

  isPersonalDidChange: ( ->
    return if @get('isNew')
    return if @get('isSaving')
    @get('store').commit()
  ).observes('isPersonal')

  toggleFormBox: ->
    @toggleProperty 'showFormBox'

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

  callForm: Radium.computed.newForm('call')

  callFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    contact: @get('contact')
  ).property('model', 'tomorrow', 'contact')

  toggleMeta: -> @toggleProperty 'showMeta'
  toggleReplyForm: -> @toggleProperty 'showReplyForm'
  toggleForwardForm: -> @toggleProperty 'showForwardForm'

  replyEmail: (->
    Radium.ReplyForm.create
      email: @get('model')
  ).property('model')

  forwardEmail: (->
    Radium.ForwardEmailForm.create
      email: @get('model')
  ).property('model')

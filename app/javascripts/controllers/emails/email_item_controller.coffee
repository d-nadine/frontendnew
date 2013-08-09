Radium.EmailsItemController = Radium.ObjectController.extend
  showMeta : false

  toggleSwitch: ->
    @toggleProperty 'isPersonal'

  isPersonal: ( (key, value) ->
    return if @get('isNew')
    return if @get('model.isSaving')
    return if @get('model.isSending')
    if arguments.length == 2
      @set('model.isPersonal', value)
      @get('store').commit()
    else
      @get('model.isPersonal')
  ).property('model.isPersonal')

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

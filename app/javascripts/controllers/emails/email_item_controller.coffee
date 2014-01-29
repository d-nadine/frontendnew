Radium.EmailsItemController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  needs: ['messages']
  hideUploader: true
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return

    showForm: (form) ->
      @setProperties
        showFormBox: true
        currentForm: form

      @set 'formBox.activeForm', form
      return

    toggleMeta: ->
      @toggleProperty 'showMeta'
      return

    toggleReplyForm: ->
      @set 'showForwardForm', false
      @toggleProperty 'showReplyForm'
      return

    toggleForwardForm: ->
      @set 'showReplyForm', false
      @toggleProperty 'showForwardForm'
      return

    makePublic: ->
      @set('model.isPersonal', false)
      @get('store').commit()

    deleteEmail: (item) ->
      if @get('showReplyForm')
        @set('showReplyForm', false)
        @set('showForwardForm', false)
        return

      if @get('showForwardForm')
        @set('showReplyForm', false)
        @set('showForwardForm', false)
        return

      @send 'delete', item

    cancelCheckForResponse: (email) ->
      email.set 'checkForResponse', null

      email.one 'didUpdate', (result) =>
        @send 'flashSuccess', 'Response check cancelled'

      @get('store').commit()

  showMeta : false
  currentForm: 'todo'

  hideForm: ->
    @set 'showFormBox', false
    @set 'formBox.activeForm', null

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')
      # disable for now
      # callForm: @get('callForm')
  ).property('todoForm', 'callForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    description: "Follow up with #{@get('model.subject')} email tomorrow."
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call')

  meetingForm: Radium.computed.newForm('meeting')
  meetingFormDefaults: ( ->
    isExpanded: true
    topic: null
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()
  ).property('model', 'now')

  callFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    contact: @get('contact')
  ).property('model', 'tomorrow', 'contact')

  replyEmail: (->
    Radium.ReplyForm.create
      email: @get('model')
      currentUser: @get('currentUser')
  ).property('model')

  forwardEmail: (->
    Radium.ForwardEmailForm.create
      email: @get('model')
  ).property('model')

Radium.EmailsItemController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  Radium.EmailDealMixin,

  needs: ['messages', 'deals']
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
      @set('showforwardform', false)
      @set('showingadddeal', false)

      @toggleProperty 'showReplyForm'
      return

    toggleForwardForm: ->
      @set('showingadddeal', false)
      @set('showReplyForm', false)

      @toggleProperty 'showForwardForm'
      return

    makePublic: ->
      @set('model.isPersonal', false)
      @get('store').commit()

    deleteEmail: (item) ->
      if @get('showReplyForm')
        @send 'closeForms'
        return

      if @get('showForwardForm')
        @send 'closeForms'

        return

      parentController = @get('parentController')

      if parentController instanceof Radium.EmailThreadItemController
        if item != parentController.get('selectedEmail')
          parentController.send 'deleteEmail', item
          return false

      @send 'delete', item

    cancelCheckForResponse: (email) ->
      email.set 'checkForResponse', null

      email.one 'didUpdate', (result) =>
        @send 'flashSuccess', 'Response check cancelled'

      @get('store').commit()

    closeForms: ->
      @set('showReplyForm', false)
      @set('showForwardForm', false)
      @set('showingAddDeal', false)

    toggleAddDealForm: ->
      @set('showReplyForm', false)
      @set('showForwardForm', false)
      @toggleProperty 'showingAddDeal'

      false

    hideForm: ->
      @set 'showFormBox', false
      @set 'formBox.activeForm', null

  showMeta : false
  currentForm: 'todo'

  formBox: Ember.computed 'todoform', 'callform', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')
      # disable for now
      # callForm: @get('callForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    description: "Follow up with #{@get('model.subject')} email tomorrow."

  callForm: Radium.computed.newForm('call')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    isExpanded: true
    topic: null
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()

  callFormDefaults: Ember.computed 'model', 'tomorrow', 'contact', ->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    contact: @get('contact')

  replyEmail: Ember.computed 'model', ->
    Radium.ReplyForm.create
      repliedTo: @get('model')
      currentUser: @get('currentUser')

  forwardEmail: Ember.computed 'model', ->
    Radium.ForwardEmailForm.create
      email: @get('model')

Radium.EmailsItemController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  Radium.SaveEmailMixin,
  Radium.EmailDealMixin,
  Radium.TrackContactMixin,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return

    showCommentBox: ->
      @toggleProperty 'showCommentBox'
      false

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
      @set('showForwardForm', false)
      @set('showingAddDeal', false)

      @toggleProperty 'showReplyForm'
      return

    toggleForwardForm: ->
      @set('showingAddDeal', false)
      @set('showReplyForm', false)

      @toggleProperty 'showForwardForm'
      return

    makePublic: ->
      @set('model.isPersonal', false)
      @get('store').commit()

    archiveEmail: (item) ->
      @removeSidebarItem(item, 'archive')

    deleteEmail: (item) ->
      @removeSidebarItem(item, 'delete')

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

  removeSidebarItem: (item, action) ->
    if @get('showReplyForm')
      @send 'closeForms'
      return

    if @get('showForwardForm')
      @send 'closeForms'

      return

    parentController = @get('parentController')

    @send action, item

  showMeta : false
  currentForm: 'todo'

  isTracked: Ember.computed 'sender', 'sender.isPublic', ->
    sender = @get('sender')

    return false unless sender instanceof Radium.Contact

    sender.get('isPublic')

  notTracked: Ember.computed 'sender', 'sender.isPublic', ->
    sender = @get('sender')

    return false unless sender instanceof Radium.Contact

    not sender.get('isPublic')

  senderIsCurrentUser: Ember.computed 'sender', 'currentUser', ->
    @get('currentUser') == @get('sender')

  notFromUser: Ember.computed.not 'senderIsCurrentUser'

  formBox: Ember.computed 'todoform', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')

  todoForm: Radium.computed.newForm('todo')

  email: Ember.computed 'model', ->
    model = @get('model')
    if model instanceof Radium.ObjectController
      model.get('model')
    else
      model

  todoFormDefaults: Ember.computed 'email', 'tomorrow', ->
    reference: @get('email')
    finishBy: null
    user: @get('currentUser')
    description: "Follow up with #{@get('model.subject')} email tomorrow."

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    isExpanded: true
    topic: null
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()

  replyEmail: Ember.computed 'model', ->
    replyForm = Radium.ReplyForm.create
      currentUser: @get('currentUser')

    replyForm.set('repliedTo', @get('email'))

    replyForm

  forwardEmail: Ember.computed 'model', ->
    Radium.ForwardEmailForm.create
      email: @get('model')

  needs: ['tags', 'contacts', 'users', 'userSettings', 'deals', 'peopleIndex', 'messages', 'messagesSidebar']

  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'

  deals: Ember.computed.oneWay 'controllers.deals'

  hideUploader: true
  hasComments: Ember.computed.bool 'comments.length'
  renderComments: Ember.computed.or 'hasComments', 'showCommentBox'

  canArchive: Ember.computed 'controllers.messages.folder', ->
    @get('controllers.messages.folder') != 'archive'

  _initialize: Ember.on 'init', ->
    @set('showForwardForm', false)
    @set('showingAddDeal', false)
    @set('showReplyForm', false)

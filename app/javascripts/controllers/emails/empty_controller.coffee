Radium.EmailsEmptyController = Radium.ObjectController.extend
  needs: ['messages', 'application']
  actions:
    transitionToEmail: ->
      email = @get('controllers.messages.firstObject')
      @transitionToRoute 'emails.show', @get('folder'), email

  currentPath: Ember.computed.alias 'controllers.application.currentPath'
  folder: Ember.computed.alias 'controllers.messages.folder'

  init: ->
    @_super.apply this, arguments
    Ember.addObserver(@get('controllers.messages'), 'content.[]',  this, 'messagesLengthDidChange')
    unless @get('currentUser.initialMailImported')
      Ember.addObserver(@get('currentUser'), 'initialMailImported', this, 'emailsImported')

  messagesLengthDidChange: ->
    return unless @get('currentPath') == "messages.emails.empty"
    messages = @get('controllers.messages.content')
    return unless messages.get('length')

    Ember.removeObserver(@get('controllers.messages'), 'content.[]',  this, 'messagesLengthDidChange')

    @send 'transitionToEmail'

  emailsImported: ->
    return unless @get('currentUser.initialMailImported')

    Ember.removeObserver(@get('currentUser'), 'initialMailImported', this, 'emailsImported')

    @send 'transitionToEmail'


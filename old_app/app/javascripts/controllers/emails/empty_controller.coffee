Radium.EmailsEmptyController = Radium.ObjectController.extend
  needs: ['messages']
  actions:
    transitionToEmail: ->
      messagesController = @get('controllers.messages')
      email = messagesController.get('firstObject')

      nextRoute = messagesController.get('nextRoute')

      @transitionToRoute nextRoute, @get('folder'), email

  currentPath: Ember.computed.alias 'controllers.application.currentPath'
  folder: Ember.computed.alias 'controllers.messages.folder'

  init: ->
    @_super.apply this, arguments
    remaining = @get('controllers.messages').reject((item) => item.get('isDeleted'))

    if remaining.length
      @send 'transitionToEmail'
      return

    Ember.addObserver(@get('controllers.messages'), 'content.[]',  this, 'messagesLengthDidChange')

  messagesLengthDidChange: ->
    return unless @get('currentPath') == "messages.emails.empty"
    messages = @get('controllers.messages.content')
    return unless messages.get('length')

    Ember.removeObserver(@get('controllers.messages'), 'content.[]',  this, 'messagesLengthDidChange')

    @send 'transitionToEmail'

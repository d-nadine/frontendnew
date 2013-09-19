Radium.EmailsEmptyController = Radium.ObjectController.extend
  needs: ['messages', 'application']
  currentPath: Ember.computed.alias 'controllers.application.currentPath'
  init: ->
    @_super.apply this, arguments
    Ember.addObserver(@get('controllers.messages'), 'content.[]',  this, 'messagesLengthDidChange')

  messagesLengthDidChange: ->
    return unless @get('currentPath') == "messages.emails.empty"
    messages = @get('controllers.messages.content')
    return unless messages.get('length')

    Ember.removeObserver(@get('controllers.messages'), 'content.[]',  this, 'messagesLengthDidChange')

    @transitionToRoute 'messages'

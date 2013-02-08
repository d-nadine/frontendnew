Radium.MessagesBulkActionItemController = Ember.ObjectController.extend
  needs: ['messagesBulkActions']
  activeForm: Ember.computed.alias 'controllers.messagesBulkActions.activeForm'
  summary: ( ->
    @get('message') || @get('topic')
  ).property('message')

  person: ( ->
    @get('sender') || @get('user')
  ).property('user', 'sender')

  timestamp: ( ->
    @get('sentAt') || @get('createdAt')
  ).property('sentAt', 'createdAt')

  # FIXME: activeForm observer not firing
  isDisabled: (->
    activeForm = @get('activeForm')

    return false unless activeForm

    return true if @get('model').constructor == Radium.Discussion && activeForm != 'todo'

    false
  ).property('activeForm')

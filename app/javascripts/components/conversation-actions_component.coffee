Radium.ConversationActionsComponent = Ember.Component.extend
  actions:
    updateConversation: (action, contact) ->
      actionTarget = @get('actionTarget')

      actionTarget.send "updateConversation", action, this, contact

      false

    ignoreDomain: (contact) ->
      @get('actionTarget').send "ignoreDomain", contact

      false

  actionTarget: Ember.computed.oneWay 'targetObject.parentController.targetObject'

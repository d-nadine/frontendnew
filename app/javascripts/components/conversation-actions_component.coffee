Radium.ConversationActionsComponent = Ember.Component.extend
  actions:
    updateConversation: (action, contact) ->
      parent = @get('parent')

      parent.send "updateConversation", action, this, contact

      false

    ignoreDomain: (contact) ->
      @get('parent').send "ignoreDomain", contact

      false

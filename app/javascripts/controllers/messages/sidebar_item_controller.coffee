Radium.MessagesSidebarItemController = Radium.ObjectController.extend
  needs: ['messages']
  selectedContent: Ember.computed.alias('controllers.messages.selectedContent')
  isSelectable: Ember.computed.alias('controllers.messages.canSelectItems')

  isSelected: (->
    @get('content') == @get('selectedContent')
  ).property('selectedContent')

  timestamp: (->
    @get('sentAt') || @get('createdAt')
  ).property()

  fromUser: Ember.computed 'model', ->
    unless sender = @get('sender')
      return

    sender.constructor is Radium.User && sender != @get('currentUser')

  hasLead: Ember.computed 'model', ->
    unless sender = @get('sender')
      return

    sender.constructor is Radium.Contact && sender.get('isLead')

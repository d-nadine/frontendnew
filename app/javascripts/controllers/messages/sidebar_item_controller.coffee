Radium.MessagesSidebarItemController = Radium.ObjectController.extend Radium.EmailDealMixin,
  needs: ['messages']
  selectedContent: Ember.computed.alias('controllers.messages.selectedContent')
  isSelectable: Ember.computed.alias('controllers.messages.canSelectItems')

  isSelected: (->
    @get('content') == @get('selectedContent')
  ).property('selectedContent')

  timestamp: (->
    @get('sentAt') || @get('createdAt')
  ).property()

  fromUser: Ember.computed 'sender', ->
    unless sender = @get('sender')
      return

    sender.constructor is Radium.User && sender != @get('currentUser')

  hasLead: Ember.computed 'sender', ->
    unless sender = @get('sender')
      return

    sender.constructor is Radium.Contact && sender.get('isLead')

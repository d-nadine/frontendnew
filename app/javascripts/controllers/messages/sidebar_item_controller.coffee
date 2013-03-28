Radium.MessagesSidebarItemController = Ember.ObjectController.extend
  needs: ['messages']
  selectedContent: Ember.computed.alias('controllers.messages.selectedContent')
  isSelectable: Ember.computed.alias('controllers.messages.canSelectItems')

  isSelected: (->
    @get('content') == @get('selectedContent')
  ).property('selectedContent')

  timestamp: (->
    @get('sentAt') || @get('createdAt')
  ).property()

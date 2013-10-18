Radium.MessagesSidebarItemController = Radium.ObjectController.extend
  needs: ['messages']

  actions:
    checkMessageItem: ->
      console.log 'here'

  selectedContent: Ember.computed.alias('controllers.messages.selectedContent')
  isSelectable: Ember.computed.alias('controllers.messages.canSelectItems')

  isSelected: (->
    @get('content') == @get('selectedContent')
  ).property('selectedContent')

  timestamp: (->
    @get('sentAt') || @get('createdAt')
  ).property()

Radium.MessagesSidebarItemController = Ember.ObjectController.extend
  needs: ['messages']

  isSelected: (->
    @get('content') == @get('controllers.messages.selectedContent')
  ).property('controllers.messages.selectedContent')

Radium.MessagesSidebarItemController = Ember.ObjectController.extend
  needs: ['messages']

  isContact: (->
    @get('content').constructor == Radium.Contact
  ).property('content')

  isSelected: (->
    @get('content') == @get('controllers.messages.selectedContent')
  ).property('controllers.messages.selectedContent')

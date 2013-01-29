Radium.EmailsSidebarItemController = Ember.ObjectController.extend
  needs: ['emails']

  isSelected: (->
    @get('content') == @get('controllers.emails.selectedContent')
  ).property('controllers.emails.selectedContent')

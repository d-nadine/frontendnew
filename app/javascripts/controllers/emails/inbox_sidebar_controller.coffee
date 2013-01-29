Radium.EmailsSidebarController = Em.ArrayController.extend
  needs: ['emails']

  sortProperties: ['sentAt']

  contentBinding: Ember.Binding.oneWay 'controllers.emails'
  selectedContentBinding: Ember.Binding.oneWay 'controllers.emails.selectedContent'

  itemController: 'emails_sidebar_item'

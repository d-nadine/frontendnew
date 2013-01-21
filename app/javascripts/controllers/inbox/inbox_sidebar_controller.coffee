Radium.InboxSidebarController = Em.ArrayController.extend
  sortProperties: ['sentAt']
  contentBinding: Ember.Binding.oneWay 'inboxController'
  targetBinding: Ember.Binding.oneWay 'inboxController'
  selectedContentBinding: Ember.Binding.oneWay 'inboxController.selectedContent'

Radium.SidebarEmailToolbarController = Em.ArrayController.extend
  contentBinding: 'inboxController'
  folderBinding: Ember.Binding.oneWay 'inboxController.folder'
  targetBinding: Ember.Binding.oneWay 'inboxController'

Radium.MessagesSidebarController = Radium.ArrayController.extend
  needs: ['messages']

  folder: Ember.computed.alias 'controllers.messages.folder'

  contentBinding: Ember.Binding.oneWay 'controllers.messages'
  selectedContentBinding: Ember.Binding.oneWay 'controllers.messages.selectedContent'

  itemController: 'messagesSidebarItem'

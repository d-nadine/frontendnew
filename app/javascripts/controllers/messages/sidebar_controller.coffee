Radium.MessagesSidebarController = Em.ArrayController.extend
  needs: ['messages']

  contentBinding: Ember.Binding.oneWay 'controllers.messages'
  selectedContentBinding: Ember.Binding.oneWay 'controllers.messages.selectedContent'

  itemController: 'messagesSidebarItem'

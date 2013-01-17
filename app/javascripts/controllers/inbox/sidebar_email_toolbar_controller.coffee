Radium.SidebarEmailToolbarController = Em.ArrayController.extend
  contentBinding: 'inboxController'
  folderBinding: Ember.Binding.oneWay 'inboxController.folder'

  # FIXME: find out a way to do this without delegation
  toggleChecked: ->
    @get('inboxController').toggleChecked()

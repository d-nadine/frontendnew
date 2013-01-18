Radium.InboxDrawerButtonsController = Ember.Controller.extend
  toggleFolders: (event, context) ->
    @get('drawerPanelController').toggleDrawer "folders"

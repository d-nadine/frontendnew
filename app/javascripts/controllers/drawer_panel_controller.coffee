Radium.DrawerPanelController = Ember.Controller.extend
  toggleDrawer: (name) ->
    if @get('view')
      @disconnectOutlet()
    else
      @connectOutlet name

  toggleNotifications: ->
    @toggleDrawer 'notifications'

Radium.DrawerPanelController = Ember.Controller.extend

  toggleDrawer: (name) ->
    if @get('currentDrawer') == name
      @set 'currentDrawer', undefined
      @disconnectOutlet()
    else
      @set 'currentDrawer', name
      @connectOutlet name

  disconnectDrawer: ->
    @set 'currentDrawer', undefined
    @disconnectOutlet()

  connectDrawer: (name) ->
    return if @get('currentDrawer') == name

    @set 'currentDrawer', name
    @connectOutlet name

  toggleNotifications: ->
    @toggleDrawer 'notifications'

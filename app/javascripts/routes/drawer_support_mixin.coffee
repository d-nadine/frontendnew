Radium.DrawerSupportMixin = Ember.Mixin.create
  toggleDrawer: (name) ->
    if @get('router.openDrawer') == name
      # FIXME: find a way to disconnect this
      @render 'nothing', into: 'drawer_panel'
      @set 'router.openDrawer', null
    else
      @render name, into: 'drawer_panel'
      @set 'router.openDrawer', name

  closeDrawer: ->
    @render 'nothing', into: 'drawer_panel'
    @set 'router.openDrawer', name

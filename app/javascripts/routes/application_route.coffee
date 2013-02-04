require 'routes/drawer_support_mixin'

Radium.ApplicationRoute = Ember.Route.extend Radium.DrawerSupportMixin,
  events:
    toggleDrawer: (name) ->
      @toggleDrawer name

  setupController: ->
    @controllerFor('users').set 'model', Radium.User.find()

  renderTemplate: ->
    @render()

    @render 'drawer_panel',
      into: 'application'
      outlet: 'drawerPanel'

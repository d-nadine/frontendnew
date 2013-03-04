require 'routes/drawer_support_mixin'

Radium.ApplicationRoute = Ember.Route.extend Radium.DrawerSupportMixin,
  events:
    toggleDrawer: (name) ->
      @toggleDrawer name

  setupController: ->
    @controllerFor('currentUser').set 'model', Radium.User.find(1)
    @controllerFor('users').set 'model', Radium.User.find()
    @controllerFor('contacts').set 'model', Radium.Contact.find()
    @controllerFor('clock').set 'model', Ember.DateTime.create()
    @controllerFor('groups').set 'model', Radium.Group.find()
    settings = Radium.Settings.find(1)

    @controllerFor('settings').set 'model', settings

  renderTemplate: ->
    @render()

    @render 'drawer_panel',
      into: 'application'
      outlet: 'drawerPanel'

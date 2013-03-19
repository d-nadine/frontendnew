require 'routes/drawer_support_mixin'

Radium.ApplicationRoute = Ember.Route.extend Radium.DrawerSupportMixin,
  events:
    toggleDrawer: (name) ->
      @toggleDrawer name

    back: ->
      history = @get('router.history')

      if history.length > 2
        history.pop()
        lastPage = history.pop()
      else if history.length == 2
        lastPage = history.shift()
        history.clear()
      else
        return

      if lastPage[1]
        @transitionTo lastPage[0], lastPage[1]
      else
        @transitionTo lastPage[0]

  setupController: ->
    @controllerFor('currentUser').set 'model', Radium.User.find(1)
    @controllerFor('users').set 'model', Radium.User.find()
    @controllerFor('contacts').set 'model', Radium.Contact.find()
    @controllerFor('groups').set 'model', Radium.Group.find()

    @controllerFor('clock').set 'model', Ember.DateTime.create()

    settings = Radium.Settings.find(1)
    @controllerFor('settings').set 'model', settings

  renderTemplate: ->
    @render()

    @render 'drawer_panel',
      into: 'application'
      outlet: 'drawerPanel'

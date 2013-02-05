require 'routes/drawer_support_mixin'

Radium.ApplicationRoute = Ember.Route.extend Radium.DrawerSupportMixin,
  events:
    toggleDrawer: (name) ->
      @toggleDrawer name

  setupController: ->
    @controllerFor('users').set 'model', Radium.User.find()
    settings = Radium.Settings.find(1)

    # FIXME: should not have to load statuses separately.  Something weird
    statuses = Radium.PipelineStatus.all()

    settings.get('pipelineStatuses').pushObjects(statuses)
    @controllerFor('settings').set 'model', settings

  renderTemplate: ->
    @render()

    @render 'drawer_panel',
      into: 'application'
      outlet: 'drawerPanel'

Radium.SettingsRemindersAlertsRoute = Radium.Route.extend Radium.ModelDeactivateMixin,
  model: ->
    @controllerFor('currentUser').get('model.settings.notifications')

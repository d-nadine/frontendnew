Radium.SettingsProfileRoute = Radium.Route.extend Radium.ModelDeactivateMixin,
  model: ->
    @controllerFor('currentUser').get('model')

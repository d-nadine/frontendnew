Radium.SettingsApiRoute = Radium.Route.extend
  model: ->
    @controllerFor('currentUser').get('model')

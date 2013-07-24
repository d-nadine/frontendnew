Radium.SettingsProfileRoute = Radium.Route.extend Radium.ModelDeactivateMixin,
  setupController: (controller, model) ->
    currentUser = @controllerFor('currentUser').get('model')
    controller.set('model', currentUser)

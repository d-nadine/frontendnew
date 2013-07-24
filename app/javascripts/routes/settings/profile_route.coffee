Radium.SettingsProfileRoute = Radium.Route.extend
  setupController: (controller, model) ->
    currentUser = @controllerFor('currentUser').get('model')
    controller.set('model', currentUser)

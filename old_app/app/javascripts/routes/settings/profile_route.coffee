Radium.SettingsProfileRoute = Radium.Route.extend Radium.ModelDeactivateMixin,
  model: ->
    @get('currentUser')

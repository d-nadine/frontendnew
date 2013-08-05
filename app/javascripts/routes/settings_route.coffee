Radium.SettingsRoute = Radium.Route.extend()

Radium.SettingsIndexRoute = Radium.Route.extend
  beforeModel: ->
    @.transitionTo 'settings.profile'

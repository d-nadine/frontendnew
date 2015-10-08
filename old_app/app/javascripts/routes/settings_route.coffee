Radium.SettingsRoute = Radium.Route.extend()

Radium.SettingsIndexRoute = Radium.Route.extend
  beforeModel: ->
    @replaceWith 'settings.profile'

Radium.SettingsRoute = Radium.Route.extend
  model: ->
    Radium.Settings.find(1)

Radium.SettingsIndexRoute = Radium.Route.extend
  redirect: ->
    @.transitionTo 'settings.profile'

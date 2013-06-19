Radium.SettingsRoute = Radium.Route.extend()

Radium.SettingsIndexRoute = Radium.Route.extend
  redirect: ->
    @.transitionTo 'settings.profile'

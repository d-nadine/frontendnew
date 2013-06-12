Radium.SettingsRoute = Radium.Route.extend
  redirect: ->
    @.transitionTo 'settings.account'
  renderTemplate: ->
    @render 'settings'
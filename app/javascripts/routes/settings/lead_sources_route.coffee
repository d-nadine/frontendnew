Radium.SettingsLeadSourcesRoute = Radium.Route.extend
  model: ->
    @controllerFor('account').get('leadSources')

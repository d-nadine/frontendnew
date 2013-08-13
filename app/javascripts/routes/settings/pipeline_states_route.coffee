Radium.SettingsPipelineStatesRoute = Radium.Route.extend
  model: ->
    @controllerFor('account').get('workflow')

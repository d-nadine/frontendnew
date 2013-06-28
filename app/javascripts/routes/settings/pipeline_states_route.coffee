Radium.SettingsPipelineStatesRoute = Radium.Route.extend
  model: ->
    Radium.PipelineState.find()
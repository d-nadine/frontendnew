Radium.PipelineNegotiatingRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineNegotiating').toggleChecked()

  model: ->
    @modelFor('pipeline')

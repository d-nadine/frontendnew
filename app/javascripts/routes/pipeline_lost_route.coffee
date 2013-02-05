Radium.PipelineLostRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLost').toggleChecked()

  model: ->
    @controllerFor('pipeline').get('lost')

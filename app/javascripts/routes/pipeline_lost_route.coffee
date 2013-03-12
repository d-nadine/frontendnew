Radium.PipelineLostRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLost').toggleChecked()

  model: ->
    @modelFor('pipeline').get('lost')

Radium.PipelineClosedRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineClosed').toggleChecked()

  model: (params) ->
    @controllerFor('pipeline').get('closed')

  renderTemplate: ->
    @render 'pipeline/closed'
      into: 'pipeline'

Radium.PipelineClosedRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineClosed').toggleChecked()

  model: ->
    @modelFor('pipeline').get('closed')

  renderTemplate: ->
    @render 'pipeline/closed'
      into: 'pipeline'

Radium.PipelineClosedRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineClosed').toggleChecked()

  setupController: (controller) ->
    content = @controllerFor('pipeline').get('closed')
    controller.set 'model', content

  renderTemplate: ->
    @render 'pipeline/closed'
      into: 'pipeline'

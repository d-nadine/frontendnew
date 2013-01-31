Radium.PipelineClosedRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineClosed').toggleChecked()

  model: (params) ->
    return Radium.Deal.find(statusFor: 'closed')

  renderTemplate: ->
    @render 'pipeline/closed'
      into: 'pipeline'

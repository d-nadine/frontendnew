Radium.PipelineNegotiatingRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineNegotiating').toggleChecked()

  model: (params) ->
    Radium.Deal.find(statusFor: 'negotiating')

  renderTemplate: ->
    @render 'pipeline/negotiating'
      into: 'pipeline'


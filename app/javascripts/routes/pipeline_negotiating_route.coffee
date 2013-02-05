Radium.PipelineNegotiatingRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineNegotiating').toggleChecked()

  model: (params) ->
    @controllerFor('pipeline').get('negotiating')

  renderTemplate: ->
    @render 'pipeline/negotiating'
      into: 'pipeline'


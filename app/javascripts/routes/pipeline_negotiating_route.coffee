Radium.PipelineNegotiatingRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineNegotiating').toggleChecked()

  setupController: (controller, context) ->
    groups = @controllerFor('pipeline').get('negotiatingGroups')

    controller.set 'model', groups

  renderTemplate: ->
    @render 'pipeline/negotiating'
      into: 'pipeline'


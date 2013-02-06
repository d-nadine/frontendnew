Radium.PipelineNegotiatingRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineNegotiating').toggleChecked()

  setupController: (controller) ->
    content = @controllerFor('pipeline').get('negotiatingGroups')
    controller.set 'model', content

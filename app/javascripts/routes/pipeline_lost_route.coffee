Radium.PipelineLostRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLost').toggleChecked()

  setupController: (controller) ->
    content = @controllerFor('pipeline').get('lost')
    controller.set 'model', content


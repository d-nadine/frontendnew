Radium.PipelineLeadsRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLeads').toggleChecked()

  setupController: (controller) ->
    content = @controllerFor('pipeline').get('leads')
    controller.set 'model', content

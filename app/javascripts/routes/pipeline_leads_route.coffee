Radium.PipelineLeadsRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLeads').toggleChecked()

  model: ->
    @modelFor('pipeline').get('leads')

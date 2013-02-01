Radium.PipelineLeadsRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLeads').toggleChecked()

  model: ->
    Radium.Contact.find(statusFor: 'lead')

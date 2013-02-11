Radium.PipelineLeadsRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLeads').toggleChecked()

  model: ->
    Radium.Contact.filter (contact) ->
      contact.get('status') is 'lead'

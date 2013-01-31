Radium.PipelineLostRoute = Em.Route.extend
  events:
    toggleChecked: ->
      @controllerFor('pipelineLost').toggleChecked()

  model: ->
    Radium.Contact.find(statusFor: 'lost')

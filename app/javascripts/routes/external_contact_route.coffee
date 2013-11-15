Radium.ExternalcontactsRoute = Radium.Route.extend
  model: ->
    controller = @controllerFor 'externalcontacts'
    controller.send 'reset'
    controller.set 'newPipelineDeal', null
    Radium.ExternalContact.find controller.queryParams()

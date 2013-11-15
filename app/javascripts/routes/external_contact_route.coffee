Radium.ExternalcontactsRoute = Radium.Route.extend
  model: ->
    controller = @controllerFor 'externalcontacts'
    controller.send 'reset'
    Radium.ExternalContact.find controller.queryParams()

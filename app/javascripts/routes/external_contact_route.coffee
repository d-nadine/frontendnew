Radium.ExternalcontactsRoute = Radium.Route.extend
  model: ->
    controller = @controllerFor 'externalcontacts'
    controller.send 'reset'
    controller.set 'newPipelineDeal', null
    controller.set 'searchText', null
    Radium.ExternalContact.find controller.queryParams()

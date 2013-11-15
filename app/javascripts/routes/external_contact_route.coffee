Radium.ExternalcontactsRoute = Radium.Route.extend
  model: ->
    controller = @controllerFor 'externalcontacts'
    controller.set 'newPipelineDeal', null
    controller.set 'searchText', null
    controller.send 'reset'
    controller.send 'showMore'
    controller.send 'showMore'

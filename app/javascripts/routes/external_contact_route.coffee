Radium.ExternalcontactsRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  actions:
    deleteAll: ->
      @getController().get('checkedContent').toArray().forEach (model) =>
        @send 'animateDelete', model, =>
          model.deleteRecord()

      @get('store').commit()

      @send 'close'
      return false

  model: ->
    controller = @controllerFor 'externalcontacts'
    controller.set 'newPipelineDeal', null
    controller.set 'searchText', null
    controller.send 'reset'
    controller.send 'showMore'
    controller.send 'showMore'

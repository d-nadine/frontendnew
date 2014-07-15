Radium.ExternalcontactsRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    Radium.InfiniteDataset.create
      store: @store
      type: Radium.Contact
      params: {private: true}
  actions:
    loadMoreContacts: ->
      @dataset.expand()
    deleteAll: ->
      @getController().get('checkedContent').toArray().forEach (model) =>
        @send 'animateDelete', model, =>
          model.deleteRecord()

          @get('store').commit()

      @send 'close'
      return false

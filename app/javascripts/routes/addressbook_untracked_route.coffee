Radium.AddressbookUntrackedRoute = Radium.Route.extend
  model: ->
    @dataset = Radium.InfiniteDataset.create
      store: @store
      type: Radium.Contact
      params: {private: true}
  actions:
    promote: (model, status)->
      console.log 'promote this contact'
    loadMoreContacts: ->
      @dataset.expand()

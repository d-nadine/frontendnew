Radium.AddressbookPeopleRoute = Radium.Route.extend
  model: ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Contact
      params: {public: true}
  actions:
    loadMoreContacts: ->
      @dataset.expand()

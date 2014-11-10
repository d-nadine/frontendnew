Radium.AddressbookCompaniesRoute = Radium.Route.extend
  model: ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Company

  actions:
    loadMoreCompanies: ->
      @dataset.expand()



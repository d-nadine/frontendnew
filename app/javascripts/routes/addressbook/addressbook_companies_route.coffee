Radium.AddressbookCompaniesRoute = Radium.Route.extend
  model: ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Company
      params: {}

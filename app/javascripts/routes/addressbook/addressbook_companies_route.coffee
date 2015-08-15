Radium.AddressbookCompaniesRoute = Radium.Route.extend
  model: ->
    Radium.InfiniteDataset.create
      type: Radium.Company
      params: {}

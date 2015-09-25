Radium.AddressbookCompaniesRoute = Radium.Route.extend
  model: ->
    Radium.InfiniteDataset.create
      type: Radium.Company
      params: {}

  deactivate: ->
    @_super.apply this, arguments
    @controllerFor('addressbookCompanies').closeAllDrawers()

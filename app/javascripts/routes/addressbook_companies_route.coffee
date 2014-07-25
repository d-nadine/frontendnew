Radium.AddressbookCompaniesRoute = Radium.Route.extend
  model: ->
    Radium.Company.find({})

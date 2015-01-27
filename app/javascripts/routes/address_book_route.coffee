Radium.AddressbookRoute = Radium.Route.extend
  setupController: (controller, model) ->
    controller.send 'updateTotals'

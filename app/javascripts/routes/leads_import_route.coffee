Radium.LeadsImportRoute = Radium.Route.extend
  deactivate: ->
    @controller.send 'reset'

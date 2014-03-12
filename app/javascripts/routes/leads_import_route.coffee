Radium.LeadsImportRoute = Radium.Route.extend
  model: ->
    Radium.ContactImportJob.find()

  deactivate: ->
    @controller.send 'reset'

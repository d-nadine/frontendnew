Radium.SettingsContactStatusesRoute = Radium.Route.extend
  model: ->
    Radium.ContactStatus.find()

  deactivate: ->
    @controller.get('model').filter((a) -> a.get('isNew'))
                            .forEach (a) -> a.unloadRecord()

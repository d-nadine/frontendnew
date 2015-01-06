Radium.SettingsContactStatusesRoute = Radium.Route.extend
  model: ->
    Radium.ContactStatus.find()
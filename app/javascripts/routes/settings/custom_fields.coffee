Radium.SettingsCustomFieldsRoute = Radium.Route.extend
  model: ->
    settings = Radium.Settings.find(1)
    settings.get('customFields')
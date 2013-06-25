Radium.SettingsRemindersAlertsRoute = Radium.Route.extend
  model: ->
    Radium.Settings.find(1).get('reminders')
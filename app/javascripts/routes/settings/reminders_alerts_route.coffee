Radium.SettingsRemindersAlertsRoute = Radium.Route.extend
  model: ->
    transaction = @store.transaction()
    test = Radium.Settings.find(1)
    transaction.add test
    test
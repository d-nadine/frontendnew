Radium.SettingsRemindersAlertsRoute = Radium.Route.extend
  model: ->
    transaction = @store.transaction()
    settings = Radium.Settings.find(1)
    transaction.add settings
    settings

  events:
    save: (settings) ->
      settings.get('transaction').commit()

    cancel: (settings) ->
      settings.get('transaction').rollback()
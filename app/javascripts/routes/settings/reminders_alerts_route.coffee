Radium.SettingsRemindersAlertsRoute = Radium.Route.extend
  model: ->
    transaction = @store.transaction()
    settings = Radium.Settings.find(1)
    transaction.add settings
    settings

  events:
    save: (settings) ->
      @send('flashMessage',
        type: 'alert-success'
        message: "Reminders & Alerts settings saved!"
      )
      settings.get('transaction').commit()

    cancel: (settings) ->
      settings.get('transaction').rollback()
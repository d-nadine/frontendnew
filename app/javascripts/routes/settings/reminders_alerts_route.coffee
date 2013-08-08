Radium.SettingsRemindersAlertsRoute = Radium.Route.extend
  model: ->
    @controllerFor('userSettings').get('model')

  events:
    save: (settings) ->
      @send('flashMessage',
        type: 'alert-success'
        message: "Reminders & Alerts settings saved!"
      )
      settings.get('transaction').commit()

    cancel: (settings) ->
      settings.get('transaction').rollback()

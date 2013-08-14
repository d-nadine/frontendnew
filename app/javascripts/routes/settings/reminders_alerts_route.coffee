Radium.SettingsRemindersAlertsRoute = Radium.Route.extend Radium.ModelDeactivateMixin,
  model: ->
    @controllerFor('currentUser').get('model.settings')

  deactivate: ->
    @_super.apply this, arguments
    model = this.get('currentModel')
    model.get('transaction').rollback() unless model.get('isSaving')

Radium.SettingsGeneralRoute = Radium.Route.extend
  actions:
    deleteExcludedDomain: (domain) ->
      @controllerFor('settingsGeneral').get('model').removeObject(domain)

      domain.delete()

      false

  model: ->
    Radium.ExcludedDomain.find({})

Radium.SettingsIntegrationsRoute = Ember.Route.extend
  model: ->
    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.ThirdpartyIntegration.find({}).then (result) ->
        resolve result.mapProperty('name')

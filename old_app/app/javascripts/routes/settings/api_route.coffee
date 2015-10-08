Radium.SettingsApiRoute = Radium.Route.extend
  actions:
    openIntercom: ->
      Intercom('show')

  model: ->
    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.ThirdpartyIntegration.find({}).then (result) ->
        resolve result.mapProperty('name')

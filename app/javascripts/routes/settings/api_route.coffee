Radium.SettingsApiRoute = Radium.Route.extend
  model: ->
    @get('currentUser')

  actions:
    openIntercom: ->
      Intercom('show')
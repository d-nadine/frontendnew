Radium.SettingsCompanyRoute = Radium.Route.extend
  model: ->
    Radium.Settings.find(1)

  events:
    deleteUser: (user) ->
      c = confirm("Are you sure you want to delete #{user.get('name')}? This cannot be undone")

      user.deleteRecord() if c
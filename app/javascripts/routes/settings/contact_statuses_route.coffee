require 'mixins/remove_all_new_on_deactivate'

Radium.SettingsContactStatusesRoute = Radium.Route.extend Radium.RemoveAllNewOnDeactivate,
  model: ->
    Radium.ContactStatus.find()

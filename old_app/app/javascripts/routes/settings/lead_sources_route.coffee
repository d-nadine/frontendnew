require 'mixins/remove_all_new_on_deactivate'

Radium.SettingsLeadSourcesRoute = Radium.Route.extend Radium.RemoveAllNewOnDeactivate,
  model: ->
    @controllerFor('account').get('leadSources')

  deactivate: ->
    controller = @controller

    controller.get('leadSources').filter((a) -> a.get('isNew'))
                            .forEach (a) -> controller.get('leadSources').removeObject a

Radium.AccountSettingsController = Radium.ObjectController.extend
  leadSources: Ember.computed 'model.leadSources', ->
    return unless @get('model.leadSources')

    @get('model.leadSources')

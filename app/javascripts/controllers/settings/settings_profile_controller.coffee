Radium.SettingsProfileController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  save: ->
    @get('store').commit()
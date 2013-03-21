Radium.SettingsController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  user: Ember.computed.alias 'controllers.currentUser.settings'

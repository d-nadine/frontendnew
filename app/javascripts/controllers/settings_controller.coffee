Radium.SettingsController = Ember.ObjectController.extend Radium.CurrentUserMixin, Ember.Evented,
  user: Ember.computed.alias 'controllers.currentUser.settings'

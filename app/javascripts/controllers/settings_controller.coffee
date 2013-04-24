Radium.SettingsController = Radium.ObjectController.extend Ember.Evented,
  user: Ember.computed.alias 'controllers.currentUser.settings'

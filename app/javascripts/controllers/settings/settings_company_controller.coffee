Radium.SettingsCompanyController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: 'users'
  users: Ember.computed.alias 'controllers.users'
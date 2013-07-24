Radium.SettingsProfileView = Radium.View.extend
  firstName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.firstName'

  lastName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.lastName'

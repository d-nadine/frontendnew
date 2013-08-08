Radium.SettingsProfileView = Radium.View.extend
  firstName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.firstName'
    disabledBinding: 'controller.isUpdating'

  lastName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.lastName'
    disabledBinding: 'controller.isUpdating'

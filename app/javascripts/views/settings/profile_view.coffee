Radium.SettingsProfileView = Radium.View.extend
  firstName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.firstName'
    disabledBinding: 'controller.isSaving'

  lastName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.lastName'
    disabledBinding: 'controller.isSaving'

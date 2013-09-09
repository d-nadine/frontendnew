Radium.SettingsProfileView = Radium.View.extend
  firstName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.firstName'
    disabledBinding: 'controller.isSaving'

  lastName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.lastName'
    disabledBinding: 'controller.isSaving'

  title: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'controller.title'
    disabledBinding: 'controller.isSaving'

  phone: Ember.TextField.extend
    valueBinding: 'controller.phone'
    disabledBinding: 'controller.isSaving'



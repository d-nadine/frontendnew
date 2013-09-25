Radium.SettingsProfileView = Radium.View.extend
  firstName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'targetObject.firstName'
    disabledBinding: 'targetObject.isSaving'

  lastName: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'targetObject.lastName'
    disabledBinding: 'targetObject.isSaving'

  title: Ember.TextField.extend Radium.ValueIsInvalidMixin,
    valueBinding: 'targetObject.title'
    disabledBinding: 'targetObject.isSaving'

  phone: Ember.TextField.extend
    valueBinding: 'targetObject.phone'
    disabledBinding: 'targetObject.isSaving'



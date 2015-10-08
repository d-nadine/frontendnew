require 'lib/radium/value_validation_mixin'

Radium.SettingsProfileView = Radium.View.extend
  firstName: Ember.TextField.extend Radium.ValueIsInvalidMixin, Radium.ActionOnKeydown,
    valueBinding: 'targetObject.firstName'
    disabledBinding: 'targetObject.isSaving'
    actionHandler: 'save'

  lastName: Ember.TextField.extend Radium.ValueIsInvalidMixin, Radium.ActionOnKeydown,
    valueBinding: 'targetObject.lastName'
    disabledBinding: 'targetObject.isSaving'
    actionHandler: 'save'

  title: Ember.TextField.extend Radium.ValueIsInvalidMixin, Radium.ActionOnKeydown,
    valueBinding: 'targetObject.title'
    disabledBinding: 'targetObject.isSaving'
    actionHandler: 'save'

  phone: Ember.TextField.extend Radium.ActionOnKeydown,
    valueBinding: 'targetObject.phone'
    disabledBinding: 'targetObject.isSaving'
    actionHandler: 'save'

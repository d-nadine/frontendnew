require 'mixins/customfield_inputmixin'

Radium.CustomfieldCurrencyinputComponent = Ember.Component.extend Radium.CustomFieldInputMixin,
  classNameBindings: [':currency-input']

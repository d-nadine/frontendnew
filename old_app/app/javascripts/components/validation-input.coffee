require "mixins/validation_mixin"

Radium.ValidationInputComponent = Ember.TextField.extend Radium.ValidationMixin,
  type: 'text'

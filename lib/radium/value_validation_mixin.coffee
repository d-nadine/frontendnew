Radium.ValueIsInvalidMixin = Ember.Mixin.create
  classNameBindings: ['isInvalid']
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('controller.isSubmitted')
  ).property('value', 'controller.isSubmitted')

Radium.ValueValidationMixin = Ember.Mixin.create Radium.ValueIsInvalidMixin,
  classNameBindings: ['isValid',':field']
  isValid: (->
    value = @get 'value'
    return unless value
    true
  ).property('value')

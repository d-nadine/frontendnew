Radium.ValueIsInvalidMixin = Ember.Mixin.create
  classNameBindings: ['isInvalid']
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('targetObject.isSubmitted')
  ).property('value', 'targetObject.isSubmitted')

Radium.ValueValidationMixin = Ember.Mixin.create Radium.ValueIsInvalidMixin,
  classNameBindings: ['isValid',':field']
  isValid: (->
    value = @get 'value'
    return unless value
    true
  ).property('value')

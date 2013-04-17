Radium.ValueValidationMixin = Ember.Mixin.create
  classNameBindings: ['isValid','isInvalid',':field']
  isValid: (->
    value = @get 'value'
    return unless value
    true
  ).property('value')
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('controller.isSubmitted')
  ).property('value', 'controller.isSubmitted')

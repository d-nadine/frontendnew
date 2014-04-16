Radium.ValueIsInvalidMixin = Ember.Mixin.create
  classNameBindings: ['isInvalid']
  parent: Ember.computed.alias 'targetObject'
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('parent.isSubmitted')
  ).property('value', 'parent.isSubmitted')

Radium.ValueValidationMixin = Ember.Mixin.create Radium.ValueIsInvalidMixin,
  classNameBindings: ['isValid',':field']
  isValid: (->
    value = @get 'value'
    return unless value
    true
  ).property('value')

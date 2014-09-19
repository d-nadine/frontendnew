Radium.ValueIsInvalidMixin = Ember.Mixin.create
  classNameBindings: ['isInvalid']
  parent: Ember.computed.alias 'targetObject'
  isInvalid: Ember.computed 'value', 'parent.isSubmitted', ->
    Ember.isEmpty(@get('value')) && @get('parent.isSubmitted')

Radium.ValueValidationMixin = Ember.Mixin.create Radium.ValueIsInvalidMixin,
  classNameBindings: ['isValid',':field']
  isValid: Ember.computed 'value', ->
    value = @get 'value'
    return unless value
    true

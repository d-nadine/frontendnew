Radium.ContactCompanyMixin = Ember.Mixin.create
  classNameBindings: ['isValid','isInvalid',':company-name', ':field']

  isValid: Ember.computed 'value', ->
    value = @get 'value'
    return unless value
    true

  isInvalid: Ember.computed 'controller.isSubmitted', 'controller.name', 'controller.companyName', ->
    return unless @get('controller.isSubmitted')

    Ember.isEmpty(@get('controller.name')) && Ember.isEmpty(@get('controller.companyName'))

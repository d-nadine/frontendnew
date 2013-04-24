Radium.ContactCompanyMixin = Ember.Mixin.create
  classNameBindings: ['isValid','isInvalid',':company-name', ':field']
  isValid: (->
    value = @get 'value'
    return unless value
    true
  ).property('value')
  isInvalid: ( ->
    return unless @get('controller.isSubmitted')

    Ember.isEmpty(@get('controller.name')) && Ember.isEmpty(@get('controller.companyName'))
  ).property('controller.isSubmitted', 'controller.name', 'controller.companyName')


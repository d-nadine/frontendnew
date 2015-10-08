require 'mixins/customfield_inputmixin'

Radium.CustomfieldCurrencyinputComponent = Ember.Component.extend Radium.CustomFieldInputMixin,
  classNameBindings: [':currency-input']

  # UPGRADE: replace with inject
  accountController: Ember.computed ->
    @container.lookup('controller:account')

  localCurrency: Ember.computed ->
    @get('accountController.accountCurrency').symbol

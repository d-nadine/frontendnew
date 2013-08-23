require 'lib/radium/autocomplete_combobox'

Radium.CompanyPicker = Radium.AutocompleteCombobox.extend
  classNameBindings: [':company-picker']
  valueBinding: 'controller.company'
  placeholder: 'Company'
  queryParameters: (query) ->
    Ember.merge @_super.apply(this, arguments), scopes: 'company'

require 'lib/radium/company_picker'

Radium.ContactPicker = Radium.AutocompleteCombobox.extend
  valueBinding: 'controller.contact'
  queryParameters: (query) ->
    Ember.merge @_super.apply(this, arguments), scopes: 'contact'

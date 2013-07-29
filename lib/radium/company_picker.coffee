require 'lib/radium/autocomplete_combobox'

Radium.CompanyPicker = Radium.Combobox.extend
  classNameBindings: [':company-picker']
  sourceBinding: 'controller.controllers.companies'
  valueBinding: 'controller.company'
  placeholder: 'Company'
  autocompleteResultType: Radium.AutocompleteCompany

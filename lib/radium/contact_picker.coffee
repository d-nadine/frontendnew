require 'lib/radium/company_picker'

Radium.ContactPicker = Radium.AutocompleteCombobox.extend
  autocompleteResultType: Radium.AutocompleteContact
  valueBinding: 'controller.contact'


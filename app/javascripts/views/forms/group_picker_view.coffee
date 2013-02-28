require 'views/forms/picker_view'
Radium.FormsGroupPickerView = Radium.Combobox.extend
  label: "location"
  sourceBinding: 'controller.locations'
  valueBinding: 'controller.location'
  queryBinding: 'controller.location'

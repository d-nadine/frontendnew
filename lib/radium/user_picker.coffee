require 'lib/radium/combobox'

Radium.UserPicker = Radium.Combobox.extend
  classNameBindings: [
    ':user-picker-control-box'
  ]

  valueBinding: 'controller.user'
  sourceBinding: 'controller.controllers.users'
  label: 'Assigned to'

  lookupQuery: (query) ->
    @get('source').find (item) -> item.get('name') == query

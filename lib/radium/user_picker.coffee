require 'lib/radium/combobox'

Radium.UserPicker = Radium.Combobox.extend
  valueBinding: 'controller.user'
  sourceBinding: 'controller.controllers.users'
  leader: 'Assigned to'

  lookupQuery: (query) ->
    @get('source').find (item) -> item.get('name') == query

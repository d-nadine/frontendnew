require 'lib/radium/combobox'
Radium.LocationPicker = Radium.Combobox.extend
  label: "location"
  sourceBinding: 'controller.locations'
  valueBinding: 'controller.location'

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      @set 'value', @lookupQuery(value)
    else if !value && @get('value')
      @get 'value'
    else
      value
  ).property('value')

  setValue: (object) ->
    @set 'value', object.get('name')
    @set 'open', false

  lookupQuery: (query) ->
    @_super(query)?.get('name')

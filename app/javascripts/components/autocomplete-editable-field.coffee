require 'components/editable-field_component'
require 'components/autocomplete_mixin'

Radium.AutocompleteEditableFieldComponent = Radium.EditableFieldComponent.extend Radium.AutocompleteMixin,
  actions:
    setBindingValue: (object) ->
      @set "bufferedProxy.#{@get('bufferKey')}", object.get(@field)

  getField: ->
    @get('queryKey')

  bindQuery: ->
    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    bufferDep

  autocompleteElement: ->
    @$()

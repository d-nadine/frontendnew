require 'components/editable-field_component'
require 'components/autocomplete_mixin'

Radium.AutocompleteEditableFieldComponent = Radium.EditableFieldComponent.extend Radium.AutocompleteMixin,
  getField: ->
    @get('queryKey')

  bindQuery: ->
    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    bufferDep

  autocompleteElement: ->
    @$()
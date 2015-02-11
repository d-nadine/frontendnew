require 'components/autocomplete_mixin'

Radium.AutocompleteTextboxComponent = Ember.Component.extend Radium.AutocompleteMixin,
  classNameBindings: [':combobox-container']

  getField: ->
    @get('queryKey')

  bindQuery: ->
    'targetObject.name'

  autocompletElement: ->
    @$('input[type=text].combobox:first')

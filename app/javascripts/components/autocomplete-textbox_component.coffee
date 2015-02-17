require 'components/autocomplete_mixin'

Radium.AutocompleteTextboxComponent = Ember.Component.extend Radium.AutocompleteMixin,
  target: Em.computed.alias("targetObject")
  actions:
    setBindingValue: (object) ->
      @sendAction 'action', object.get('person')

  classNameBindings: [':combobox-container']

  getField: ->
    @get('queryKey')

  bindQuery: ->
    @get('bindQueryKey')

  autocompleteElement: ->
    @$('input[type=text].combobox:first')

  input: (e) ->
    el = @autocompleteElement()

    @set 'value', el.val()

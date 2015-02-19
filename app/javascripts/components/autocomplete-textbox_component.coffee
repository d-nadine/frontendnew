require 'components/autocomplete_mixin'

Radium.AutocompleteTextboxComponent = Ember.Component.extend Radium.AutocompleteMixin,
  actions:
    setBindingValue: (object) ->
      @sendAction 'action', object.get('person')

  classNameBindings: [':combobox-container']

  autocompleteElement: ->
    @$('input[type=text].combobox:first')

  input: (e) ->
    el = @autocompleteElement()

    @set 'query', el.val()

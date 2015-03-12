require 'components/autocomplete_mixin'

Radium.AutocompleteTextboxComponent = Ember.Component.extend Radium.AutocompleteMixin,
  actions:
    setBindingValue: (object) ->
      value = if typeof object == "string"
                object
              else
                object.get('person') || object

      @sendAction 'action', value

  classNameBindings: [':combobox-container']

  autocompleteElement: ->
    @$('input[type=text].combobox:first')

  input: (e) ->
    el = @autocompleteElement()

    @set 'query', el.val()

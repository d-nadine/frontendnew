require 'components/autocomplete_mixin'
require 'mixins/auto_fill_hack'
require 'mixins/validation_mixin'

Radium.AutocompleteTextboxComponent = Ember.Component.extend Radium.AutocompleteMixin,
  Radium.AutoFillHackMixin,
  Radium.ValidationMixin,

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

    @set 'value', el.val()

    if @get('isInvalid')
      @$().addClass 'is-invalid'
    else
      @$().removeClass 'is-invalid'

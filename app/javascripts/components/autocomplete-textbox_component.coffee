require 'components/autocomplete_mixin'

Radium.AutocompleteTextboxComponent = Ember.Component.extend Radium.AutocompleteMixin,
  actions:
    setBindingValue: (object) ->
      @set 'value', object.get(@field)
      @sendAction 'modelChanged', object

  classNameBindings: [':combobox-container']

  getField: ->
    @get('queryKey')

  bindQuery: ->
    @get('bindQueryKey')

  autocompletElement: ->
    @$('input[type=text].combobox:first')

  input: (e) ->
    el = @autocompletElement()

    @set 'value', el.val()

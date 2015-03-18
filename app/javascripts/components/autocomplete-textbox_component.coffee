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

      if @writeableValue
        @setValueText()
      else
        @set 'value', value

      @getTypeahead().hide()

      @sendAction 'action', value

      false

    showAll: ->
      return if @get('isAsync')

      typeahead = @getTypeahead()

      return typeahead.hide() if typeahead.shown

      source = @source.toArray()

      typeahead.render(source.slice(0, source.length)).show()

    removeValue: ->
      @set('value', null)
      @autocompleteElement().val('').focus()
      event.stopPropagation()
      event.preventDefault()
      false

  classNameBindings: [':combobox-container']

  autocompleteElement: ->
    @$('input[type=text].combobox:first')

  input: (e) ->
    el = @autocompleteElement()

    text = el.val()

    @query = text

    if @writeableValue
      @set 'value', text

    if @get('isInvalid')
      @$().addClass 'is-invalid'
    else
      @$().removeClass 'is-invalid'

  valueDidChange: Ember.observer 'value', ->
    @setValueText()

  initializeValue: Ember.on 'didInsertElement', ->
    @setValueText()

  setValueText: ->
    return unless value = @get('value')

    displayValue = if typeof value == 'string'
                     value
                   else
                     value.get(@queryKey)

    @autocompleteElement().val(displayValue) if displayValue

  focusIn: (e) ->
    Em.run.next =>

      return if @get('isAsync')

      el = @autocompleteElement()

      return unless el

      return @autocompleteElement().select() if el.val()

      return if @get('value')

      return unless e.target == el.get(0)

      unless el.val().length
        @send 'showAll'

    e.stopPropagation()
    e.preventDefault()
    return false

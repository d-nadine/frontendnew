require 'components/editable-field_component'
require 'components/autocomplete_mixin'
require 'components/key_constants_mixin'

Radium.AutocompleteEditableFieldComponent = Radium.EditableFieldComponent.extend Radium.AutocompleteMixin,
  Radium.KeyConstantsMixin,

  actions:
    setBindingValue: (object) ->
      @set "bufferedProxy.#{@get('bufferKey')}", object.get(@field)

      cancel = Ember.run.later =>
        @setEndOfContentEditble()
      , 50

      @set 'isEditing', false

      @$().blur()

      false

  classNameBindings: ['isEditing']

  getField: ->
    @get('queryKey')

  bindQuery: ->
    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    bufferDep

  autocompleteElement: ->
    @$()

  keyDown: (e) ->
    if e.keyCode != @ESCAPE
      return @_super.apply this, arguments

    bufferedProxy = @get('bufferedProxy')
    bufferKey = @get('bufferKey')

    original = @get('model').get(bufferKey)

    @set "bufferedProxy.#{bufferKey}", original

    @setMarkup()

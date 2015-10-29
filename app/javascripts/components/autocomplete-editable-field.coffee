require 'components/editable-field_component'
require 'components/autocomplete_mixin'
require 'components/key_constants_mixin'
require 'mixins/containing_controller_mixin'

Radium.AutocompleteEditableFieldComponent = Radium.EditableFieldComponent.extend Radium.AutocompleteMixin,
  Radium.KeyConstantsMixin,
  Radium.ContainingControllerMixin,

  actions:
    setBindingValue: (object) ->
      key = if @bufferKey
              @bufferKey
            else
              @field

      unless @get('actionOnly')
        if object instanceof DS.Model
          @set "bufferedProxy.#{@get('bufferKey')}", object.get(@field)
        else
          @set "bufferedProxy.#{@get('bufferKey')}", object.get(key)
      else
        saveAction = @get('saveAction')
        Ember.assert "You must have a saveAction specified", saveAction
        @get('containingController').send saveAction, object

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
    if e.keyCode == @ENTER
      unless this.getTypeahead().shown
        obj = {}
        obj[@bufferKey] = @get('bufferedProxy').get(@bufferKey)
        obj['id'] = @get('model.id')
        @send 'setBindingValue', Ember.Object.create obj
      else
        @_super.apply this, arguments

    if e.keyCode != @ESCAPE
      return @_super.apply this, arguments

    bufferedProxy = @get('bufferedProxy')
    bufferKey = @get('bufferKey')

    original = @get('model').get(bufferKey)

    @set "bufferedProxy.#{bufferKey}", original

    @setMarkup()

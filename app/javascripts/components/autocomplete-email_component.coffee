require 'mixins/validation_mixin'
require 'mixins/save_model_key_down'

Radium.AutocompleteEmailComponent = Ember.TextField.extend Radium.KeyConstantsMixin,
  Radium.AutocompleteMixin,
  Radium.ValidationMixin,
  Radium.KeyConstantsMixin,
  Radium.SaveModelKeyDownMixn,

  actions:
    setBindingValue: (object) ->
      @sendAction 'action', object.get('person')

  autocompleteElement: ->
    @$()

  input: (e) ->
    @_super.apply this, arguments

    el = @autocompleteElement()

    @set 'query', el.val()

  keyDown: (e) ->
    return unless e.keyCode == @ENTER

    @sendAction('saveModel') if @get('saveModel')

  type: 'email'

  focusOut: (e) ->
    @_super.apply this, arguments

    val = @autocompleteElement().val()

    return if !val || !Radium.EMAIL_REGEX.test val

    @sendAction 'queryProfile', val

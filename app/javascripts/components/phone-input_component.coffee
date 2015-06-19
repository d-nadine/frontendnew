require 'mixins/save_model_key_down'

Radium.PhoneInputComponent = Ember.TextField.extend Radium.KeyConstantsMixin,
  Radium.SaveModelKeyDownMixn,

  classNameBindings: ['isInvalid', ':masked']

  focusIn: (evt) ->
    value = @get('value')

    @set('value', '+1') unless value

    input = @$().get(0)
    pos = 100

    Ember.run.later ( ->
      input.focus()
      input.setSelectionRange pos, pos
    ), 50

  isInvalid: Ember.computed 'value', ->
    return false if @get('skipValidation')

    value = @get('value')

    return false unless value?.length

    return true unless /^(\+|0{2})/.test value

    return false if  /^[+\-\s\(\)x0-9]{5,}$/.test value

    true

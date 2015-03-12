Radium.PhoneInput = Ember.TextField.extend
  classNameBindings: ['isInvalid',':masked',':field']

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
    value = @get('value')

    return false unless value?.length

    return true unless /^(\+|0{2})/.test value

    return false if  /^[+\-\sx0-9]{5,}$/.test value

    true

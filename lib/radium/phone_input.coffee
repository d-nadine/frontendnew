Radium.PhoneInput = Ember.TextField.extend
  classNameBindings: ['isInvalid',':masked',':field']
  didInsertElement: ->
    @_super.apply this, arguments

    @$().keypress (e) ->
      validKeys = [8, 0, 120, 43, 32, 45]
      return false if validKeys.indexOf(e.which) == -1 && (e.which < 48 || e.which > 57)

  focusIn: (evt) ->
    value = @get('value')

    @set('value', '+1') unless value

    input = @$().get(0)
    pos = 100

    Ember.run.later ( ->
      input.focus()
      input.setSelectionRange pos, pos
    ), 50

  isInvalid: ( ->
    value = @get('value')

    return false unless value?.length

    return true unless /^(\+|0{2})/.test value

    return false if  /^[+\-\sx0-9]{5,}$/.test value

    true
  ).property('value')

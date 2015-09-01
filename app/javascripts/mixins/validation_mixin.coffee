Radium.Validations =
  required: ->
    value = @get('value')
    errorMessagePart = 'is a required field'

    if Ember.isEmpty value
      result = true

    unless typeof value == "string"
      result = false

    result = Ember.isEmpty($.trim(value))

    if result
      @addErrorMessage(errorMessagePart)
    else
      @removeErrorMessage(errorMessagePart)

    result

  email: ->
    value = $.trim(@get('value') || '')
    errorMessagePart = 'should be a valid email address'

    result = !Radium.EMAIL_REGEX.test value

    if result
      @addErrorMessage(errorMessagePart)
    else
      @removeErrorMessage(errorMessagePart)

    result

  or: ->
    validator = @get('validator')
    orFields = validator.get('orFields')

    Ember.assert "You must declare orFields on the #{@get('validator').constructor.toString()} instance", orFields

    errorMessagePart = "should at least be chosen"

    result = orFields.every (f) -> Ember.isEmpty(validator.get(f))

    otherValidators = @get('validator.orValidators').reject (v) => v == this

    otherValidators.forEach (v) ->
      v.set 'mainValidatorSyncing', true
      v.set 'mainValidatorIsInvalid', result
      v.notifyPropertyChange('isInvalid')

    Ember.run.next ->
      otherValidators.forEach (v) ->
        v.set 'mainValidatorSyncing', false

    if result
      @addErrorMessage(errorMessagePart)
      return result

    errorMessages = @get('validator.errorMessages').reject (m) ->
      m.indexOf(errorMessagePart) > -1

    @set('validator.errorMessages', errorMessages)

    result

Radium.ValidationMixin = Ember.Mixin.create
  classNameBindings: ['isInvalid']

  input: (e) ->
    @_super.apply this, arguments

  addErrorMessage: (errorMessagePart) ->
    errorMessage = @get('validationField') + " " + errorMessagePart
    @get('validator.errorMessages').pushObject errorMessage

  removeErrorMessage: (errorMessagePart) ->
    errorMessages = @get('validator.errorMessages')

    return unless errorMessages.get('length')

    regex = new RegExp("#{@get('validationField')} #{errorMessagePart}", 'gi')
    errorMessages = errorMessages.reject (m) -> regex.test(m)

    @set('validator.errorMessages', errorMessages)

  validationInit: Ember.on 'init', ->
    @_super.apply this, arguments

    unless validations = @get('validations')
      return

    validator = @get('validator')

    if validations.contains('or')
      unless orValidators = validator.get('orValidators')
        validator.set('orValidators', [])

      unless validator.get('orValidators').contains(this)
        validator.get('orValidators').push this

    Ember.assert 'You must spcecify a validator with validations.', validator
    Ember.assert "You must specify a validation field to build error messages.", @get('validationField')
    Ember.assert "You need to initialize an errorMessages array for the ValidationMixin.", validator.get('errorMessages')

  validationsLength: Ember.computed.oneWay 'validations.length'

  isInvalid: Ember.computed 'validator.isSubmitted', 'validator.isValid', 'value', 'errorMessages.[]', ->
    return false unless @get('validationsLength')

    if @get('mainValidatorSyncing')
      return @get('mainValidatorIsInvalid')

    validator = @get('validator')

    return false unless validator.get('isSubmitted')

    return false if validator.get('isValid')

    validations = @get('validations')

    isInvalid = validations.any (v) =>
         Radium.Validations[v].call this

    isInvalid

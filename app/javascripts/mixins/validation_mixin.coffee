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

    regex = new RegExp(errorMessagePart, 'gi')
    errorMessages = errorMessages.reject (m) -> regex.test(m)

    @set('validator.errorMessages', errorMessages)

  autocompleteInit: Ember.on 'didInsertElement', ->
    unless validations = @get('validations')
      return

    Ember.assert 'You must spcecify a validator with validations.', @get('validator')
    Ember.assert "You must specify a validation field to build error messages.", @get('validationField')

  validationsLength: Ember.computed.oneWay 'validations.length'

  isInvalid: Ember.computed 'validator.isSubmitted', 'validator.isSubmitted', 'validator.isValid', 'value', ->
    return false unless @get('validationsLength')

    validator = @get('validator')

    return false unless validator.get('isSubmitted')

    return false if validator.get('isValid')

    validations = @get('validations')

    isInvalid = validations.any (v) =>
         Radium.Validations[v].call this

    isInvalid

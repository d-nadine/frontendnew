Radium.Validations =
  required: ->
    value = @get('value')

    if Ember.isEmpty value
      return true

    unless typeof value == "string"
      return false

    Ember.isEmpty($.trim(value))

  email: ->
    value = $.trim(@get('value') || '')

    !Radium.EMAIL_REGEX.text value

Radium.ValidationMixin = Ember.Mixin.create
  classNameBindings: ['isInvalid']

  input: (e) ->
    @_super.apply this, arguments

  autocompleteInit: Ember.on 'didInsertElement', ->
    unless validations = @get('validations')
      return

    p @get('isInvalid')

    el = @autocompleteElement()

    if @get('isInvalid')
      el.addClass 'is-invalid'
    else
      el.removeClass 'is-invalid'

  validationMixin: Ember.on 'didInsertElement', ->
    unless validations = @get('validations')
      return

    validator = @get('validator')

    Ember.assert "You must specify a validator", validator

    Ember.defineProperty this, 'isInvalid', Ember.computed 'value', 'validator.isSubmitted', ->
      p "we are here"

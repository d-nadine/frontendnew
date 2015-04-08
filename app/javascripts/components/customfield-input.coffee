Radium.CustomfieldInputComponent = Ember.TextField.extend Radium.KeyConstantsMixin,
  type: 'text'

  _customFieldInputInitialise: Ember.on 'didInsertElement', ->
    customFieldValue = @get('customFieldValue')

    Ember.assert "You must supply a customFieldValue", customFieldValue

    value = customFieldValue.get('value') || ''

    @$().val(value)

  input: (e) ->
    @_super.apply this, arguments

    Ember.run.next =>
      @set 'customFieldValue.value', @$().val()

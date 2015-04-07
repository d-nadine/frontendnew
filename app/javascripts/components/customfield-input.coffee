Radium.CustomfieldInputComponent = Ember.TextField.extend Radium.KeyConstantsMixin,
  type: 'text'

  _customFieldInputInitialise: Ember.on 'didInsertElement', ->
    Ember.assert "You must bind to a cusom field", @get('customField')

  input: (e) ->
    @_super.apply this, arguments

    Ember.run.next =>
      @set 'customField.value', @$().val()

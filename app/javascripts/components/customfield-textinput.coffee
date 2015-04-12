require 'mixins/customfield_inputmixin'

Radium.CustomfieldTextinputComponent = Radium.TextArea.extend Radium.CustomFieldInputMixin,
  classNameBindings: [':customfield-textinput']
  type: 'text'
  input: (e) ->
    @_super.apply this, arguments

    Ember.run.next =>
      @set 'customFieldValue.value', @$().val()

require 'mixins/customfield_inputmixin'

Radium.CustomfieldTextinputComponent = Ember.TextField.extend Radium.CustomFieldInputMixin,
  classNameBindings: [':customfield-textinput']
  placeholder: Ember.computed 'customFieldValue.field.name', ->
    "Add #{@get('customFieldValue.field.name')}"

  type: 'text'
  input: (e) ->
    @_super.apply this, arguments

    Ember.run.next =>
      @set 'customFieldValue.value', @$().val()

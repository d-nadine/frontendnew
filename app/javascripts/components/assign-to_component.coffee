require 'mixins/inline_editor_behaviour'
require 'mixins/user_combobox_props'

Radium.AssignToComponent = Ember.Component.extend Radium.InlineEditoBehaviour,
  Radium.UserComboboxProps,
  actions:
    startEditing: ->
      @set 'form', Ember.Object.create user: null

    stopEditing: ->
      @set 'isSubmitted', true
      p @get('isValid')

    isValid: Ember.computed 'form.user', 'isSubmitted', ->
      @get('form.user')

require 'mixins/inline_editor_behaviour'
require 'mixins/user_combobox_props'

Radium.AssignToComponent = Ember.Component.extend Radium.InlineEditoBehaviour,
  Radium.UserComboboxProps,
  actions:
    startEditing: ->
      @set 'form', Ember.Object.create user: @get('user')

    stopEditing: ->
      @set 'isSubmitted', true

      return unless @get('form.user')

      @set 'isEditing', false

      @set('model.user', @get('form.user'))

      return unless @get('model.isDirty')

      @get('model').save()
        .finally => @get('isSubmitted', false)

    isValid: Ember.computed 'form.user', 'isSubmitted', ->
      @get('form.user')

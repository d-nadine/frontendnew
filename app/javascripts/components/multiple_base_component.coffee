require 'controllers/form_array_behaviour'

Radium.MultipleBaseComponent = Ember.Component.extend Radium.FormArrayBehaviour,
  actions:
    startEditing: ->
      return if @get('isSaving')

      @set 'isEditing', true

      arr = @get(@relationship)

      @createFormFromRelationship @get('model'), @relationship, arr

      false

  classNameBindings: ['isEditing:inline-editor-open']

  isEditing: false
  isSaving: false

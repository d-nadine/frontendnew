require 'controllers/form_array_behaviour'

Radium.MultipleBaseComponent = Ember.Component.extend Radium.FormArrayBehaviour,
  actions:
    startEditing: ->
      return if @get('isSaving')

      @set 'isEditing', true

      arr = @get(@relationship)

      @createFormFromRelationship @get('model'), @relationship, arr

      false

    stopEditing: ->
      @set 'isSaving', true

      arr = @get(@relationship)

      model = @get("model")

      @setModelFromHash(model, @relationship, arr)

      finish = =>
        @get(@relationship).clear()
        @set 'isEditing', false
        @set 'isSaving', false

      unless model.get('isDirty')
        finish()

      model.save().then(finish).finally =>
        @set 'isSaving', false

      false

  classNameBindings: ['isEditing:inline-editor-open']

  isEditing: false
  isSaving: false

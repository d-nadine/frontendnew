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
      @set 'isSubmitted', true

      Ember.run.next =>
        errorMessages = @get('errorMessages')

        if errorMessages.get('length')
          return @get('errorMessages').clear()

        arr = @get(@relationship)

        model = @get("model")

        @setModelFromHash(model, @relationship, arr)

        finish = =>
          @get(@relationship).clear()
          @set 'isEditing', false
          @set 'isSaving', false
          @set 'isSubmitted', false
          @get('errorMessages').clear()

        unless model.get('isDirty')
          finish()

        self = this

        model.save( ->
          self.set 'isSubmitted', false
          self.get('errorMessages').clear()
        ).then(finish).finally ->
          self.set 'isSaving', false

      false

  classNameBindings: ['isEditing:inline-editor-open']

  isEditing: false
  isSaving: false
  isSubmitted: false
  isInvalid: false
  errorMessages: Ember.A()

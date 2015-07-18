require 'controllers/form_array_behaviour'
require 'mixins/inline_editor_behaviour'

Radium.MultipleBaseComponent = Ember.Component.extend Radium.FormArrayBehaviour,
  Radium.InlineEditoBehaviour,
  actions:
    startEditing: ->
      return if @get('isSaving')

      @set 'isEditing', true

      arr = @get(@relationship)

      @createFormFromRelationship @get('model'), @relationship, arr

      Ember.run.next =>
        @$('input.field:first').focus()

      false

    stopEditing: ->
      return if @isDestroyed || @isDestroying

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
          Ember.run.next ->
            model.trigger 'modelUpdated', self, model

        isPrimaryCount = model.get(@relationship).filter((i) -> i.get('isPrimary')).toArray().length

        Ember.assert "You have 0 or more than 1 multiples with isPrimary true", isPrimaryCount <= 1

        unless model.get('isDirty')
          finish()

        self = this

        model.save().then(finish).finally ->
          self.set 'isSaving', false

      false

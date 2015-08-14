Radium.DeleteConfirmationComponent = Ember.Component.extend
  actions:
    closeConfirmationModal: ->
      @set 'showDeleteConfirmation', false

      false

    delete: ->
      @sendAction "deleteAction"

      false

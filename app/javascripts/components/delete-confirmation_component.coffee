Radium.DeleteConfirmationComponent = Ember.Component.extend
  actions:
    closeConfirmationModal: ->
      @set 'showDeleteConfirmation', false

      false

    delete: ->
      @sendAction "deleteAction"

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    confirmationMessage = @get('submitMessage') || "I understand the consequences, please delete."

    @set "confirmationMessage", confirmationMessage

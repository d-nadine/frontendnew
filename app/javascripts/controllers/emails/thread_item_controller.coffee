Radium.EmailThreadItemController = Radium.ObjectController.extend
  actions:
    deleteEmail: (email) ->
      parentController = @get('parentController')
      store = @get('store')
      adapter = store.get('_adapter')
      selectedEmail = @get('selectedEmail')

      unless @get('isSelected')
        parentController.removeObject(email)

        email.deleteRecord()

        email.one 'didDelete', =>
          @send 'flashSuccess', 'Reply deleted.'
          selectedEmail.reload()

        email.one 'becameError', (result) =>
          @send "flashError", "encountered an error while trying to delete the reply"
          result.reset()

          return false

        store.commit()

      return false

  needs: ['messages']
  selectedEmail: Ember.computed.oneWay 'controllers.messages.selectedContent'
  folder: Ember.computed.oneWay 'controllers.messages.folder'
  isSelected: Ember.computed 'model', 'selectedEmail', ->
    @get('model') == @get('selectedEmail')

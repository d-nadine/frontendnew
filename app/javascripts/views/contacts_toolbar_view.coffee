Radium.ContactsToolbarView = Ember.View.extend
  selectedContactsBinding: 'controller.selectedContacts'
  showTodoForm: (event) ->
    Radium.router.formController.show('todo', Em.ArrayProxy.create(
      contentBinding: 'context.selectedContacts'
      context: this
      name: (->
        @map( (contact) -> contact.get('displayName') ).join(', ')
      ).property('@each.displayName')
      multi: true
    ))
  totalSelectedView: Ember.View.extend
    selectedContactsBinding: "controller.selectedContacts"
    isVisible: (->
      !!@get("selectedContacts.length")
    ).property("selectedContacts")
    totalSelectedString: (->
      total = @get("selectedContacts.length")
      (if (total is 1) then total + " contact" else total + " contacts")
    ).property("selectedContacts.length")


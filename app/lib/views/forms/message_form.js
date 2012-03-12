Radium.MessageFormView = Radium.FormView.extend({
  templateName: 'message_form',
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  toFieldInput: Radium.AutocompleteTextField.extend({
    valueBinding: 'parentView.selectedContacts.firstObject.name'
  })
});
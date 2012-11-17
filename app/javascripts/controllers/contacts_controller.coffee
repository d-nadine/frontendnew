Radium.ContactsController = Em.ArrayController.extend Radium.FilteredContactsMixin,
  selectedContacts: (->
    @filter (contact) -> contact.get('isSelected')
  ).property('@each.isSelected')

require 'radium/mixins/filtered_contacts_mixin'

Radium.ContactsController = Em.ArrayController.extend Radium.FilteredContactsMixin,
  selectedContacts: (->
    @filter (contact) -> contact.get('isSelected')
  ).property('@each.isSelected')

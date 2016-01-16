Radium.SetPrimaryContactMixin = Ember.Mixin.create
  actions:
    setPrimaryContact: (contact, deal) ->
      unless contact
        @send 'flashError', 'You have not selected a contact'
        return false

      Ember.assert "contact must be contact or AutoCompleteItem", [Radium.Contact, Radium.AutocompleteItem].contains(contact.constructor)

      contact = if contact.constructor == Radium.AutocompleteItem
                  contact.get('person')
                else
                  contact

      deal.set('contact', contact)

      deal.save().then (result) =>
        @send 'flashSuccess', "#{contact.get('displayName')} is now the primary contact."

        @EventBus.publishModelUpdate deal
        @EventBus.publishModelUpdate deal.get('contact')

      false

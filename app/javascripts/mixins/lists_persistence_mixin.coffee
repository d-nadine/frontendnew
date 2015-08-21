Radium.ListsPersistenceMixin = Ember.Mixin.create
  actions:
    addList: (contact, list) ->
      return if contact.get('lists').toArray().contains list

      record = Radium.ContactList.createRecord
                 contact: contact
                 list: list

      record.save().then ->
        p "saved it bro"

      false

    removeList: (contact, list) ->
      return unless contact.get('lists').toArray().contains list


      false

  # UPGRADE: replace with inject
  lists: Ember.computed ->
    @container.lookup('controller:lists').get('sortedLists')

Radium.TrackContactMixin = Ember.Mixin.create
  actions:
    makePublic: (contact) ->
      return if contact.get('isPublic')

      contact.set('isPublic', true)

      contact.save().then ->
        contact.updateLocalProperty('isPublic', true)

      false

  # UPGRADE: replace with inject
  untrackedIndex: Ember.computed ->
    @container.lookup('controller:untrackedIndex')

  peopleIndex: Ember.computed ->
    @container.lookup('controller:peopleIndex')

  addressBook: Ember.computed ->
    @container.lookup('controller:addressbook')

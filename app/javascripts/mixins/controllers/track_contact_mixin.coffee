Radium.TrackContactMixin = Ember.Mixin.create
  actions:
    makePublic: (contact) ->
      controller = @get('untrackedIndex')

      contact.updateLocalProperty('isPublic', true)

      controller.send 'makePublic', contact, true

      false

  # UPGRADE: replace with inject
  untrackedIndex: Ember.computed ->
    @container.lookup('controller:untrackedIndex')

  peopleIndex: Ember.computed ->
    @container.lookup('controller:peopleIndex')

  addressBook: Ember.computed ->
    @container.lookup('controller:addressbook')

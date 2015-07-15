Radium.TrackContactMixin = Ember.Mixin.create
  actions:
    track: (contact) ->
      controller = @get('untrackedIndex')

      contact.updateLocalProperty('isPublic', true)

      controller.send 'track', contact, true

      false

    stopTracking: (contact) ->
      contact.updateLocalProperty('isPublic', false)

      untrack = Radium.UntrackedContact.createRecord
                  contact: contact

      untrackedController = @get('untrackedIndex')
      peopleController = @get('peopleIndex')

      currentUser = @get('currentUser')

      addressbook = @get('addressbook')

      untrack.save().then (result) =>
        @send "flashSuccess", "Contact is no longer tracked."

        untrackedController.pushObject contact

        peopleController.removeObject contact

        addressbook.send 'updateTotals'

        currentUser.reload()

  # UPGRADE: replace with inject
  untrackedIndex: Ember.computed ->
    @container.lookup('controller:untrackedIndex')

  peopleIndex: Ember.computed ->
    @container.lookup('controller:peopleIndex')

  addressBook: Ember.computed ->
    @container.lookup('controller:addressbook')

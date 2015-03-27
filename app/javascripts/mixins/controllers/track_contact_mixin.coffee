Radium.TrackContactMixin = Ember.Mixin.create
  actions:
    track: (contact) ->
      controller = @getController('untrackedIndex')

      contact.updateLocalProperty('isPublic', true)

      controller.send 'track', contact, true

      false

    stopTracking: (contact) ->
      contact.updateLocalProperty('isPublic', false)

      untrack = Radium.UntrackedContact.createRecord
                  contact: contact

      untrackedController = @getController('untrackedIndex')
      peopleController = @getController('peopleIndex')
      currentUser = @getController('currentUser').get('model')

      addressbook = @getController('addressbook')

      untrack.save(this).then (result) =>
        @send "flashSuccess", "Contact is no longer tracked."

        untrackedController.pushObject contact

        peopleController.removeObject contact

        addressbook.send 'updateTotals'

        currentUser.reload()

  needs: ['untrackedIndex', 'peopleIndex', 'addressbook']

  getController: (controller) ->
    controller = if this instanceof Ember.Route
                   @controllerFor(controller)
                 else
                   @get("controllers.#{controller}")

    Ember.assert 'controller not found in TrackContactMixin#getController', controller

    controller

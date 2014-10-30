Radium.TrackContactMixin = Ember.Mixin.create
  actions:
    track: (contact) ->
      @send 'changeTracking', contact, true

    stopTracking: (contact) ->
      @send 'changeTracking', contact, false

    changeTracking: (contact, isPublic) ->
      contact.set('isPublic', isPublic)

      contact.one 'didUpdate', (result) =>
        message = if isPublic
                    "You are now tracking #{contact.get('displayName')}"
                  else
                    "You are no longer tracking #{contact.get('displayName')}"

        @send "flashSuccess", message

      contact.one 'becameInvalid', (result) =>
        @send 'flashError', result
        @resetModel()

      contact.one 'becameError', (result) =>
        @send 'flashError', "an error has occurred."
        @resetModel()

      @get('store').commit()

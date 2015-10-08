Radium.UpdateContactPoller = Ember.Object.extend Radium.TimeoutPollerMixin,
  startPolling: ->
    contact = @get('contact')

    Ember.assert "You must have a contct to poll against.", contact

    return if @get('isPolling')
    return unless contact.get('isUpdating')

    return unless contact.get('isPublic')

    @start()

  onPoll: ->
    unless contact = @get('contact')
      return @stop()

    return @finishSync() unless contact.get('isUpdating')

    contact.one 'didReload', =>
      return @finishSync() unless contact.get('isUpdating')

    contact.reload()

  stop: ->
    @_super.apply this, arguments
    clearInterval(@_timeout) if (@_timeout)

  finishSync: ->
    @stop()

    return unless contact = @get('contact')

    observer = ->
      return unless contact.get('inCleanState')

      contact.removeObserver 'currentState.stateName', observer

      notify = ->
        contact.one 'didReload', ->
          contact.notifyPropertyChange('isUpdating')
          contact.notifyPropertyChange('avatarKey')

        contact.reload()

      if contact.get('isUpdating')
        contact.set 'updateStatus', 'updated'

        contact.save().then ->
          notify()
      else
        notify()

    unless contact.get('inCleanState')
      contact.addObserver 'currentState.stateName', observer
    else
      observer()

Radium.UpdateContactPoller = Ember.Object.extend Radium.TimeoutPollerMixin,
  startPolling: ->
    contact = @get('contact')

    Ember.assert "You must have a contct to poll against.", contact

    return if @get('isPolling')
    return unless contact.get('isUpdating')

    return unless contact.get('isPublic')

    @start()

  onPoll: ->
    return @stop() unless @get('contact.isUpdating')

    contact = @get('contact')

    contact.one 'didReload', =>
      return @stop unless @get('isUpdating')

    contact.reload()

  stop: ->
    @_super.apply this, arguments
    clearInterval(@_timeout) if (@_timeout)

  finishSync: ->
    @stop()

    return unless @get('contact.isUpdating')

    contact = @get('contact')

    observer = ->
      return unless contact.get('inCleanState')

      contact.removeObserver 'currentState.stateName', observer

      contact.set 'updateStatus', 'updated'

      contact.save().then ->
        contact.one 'didReload', ->
          contact.notifyPropertyChange('avatarKey')
        contact.reload()

    unless contact.get('inCleanState')
      contact.addObserver 'currentState.stateName', observer
    else
      observer()

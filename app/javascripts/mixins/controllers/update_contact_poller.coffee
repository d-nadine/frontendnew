Radium.UpdateContactPoller = Ember.Mixin.create Radium.TimeoutPollerMixin,
  isUpdatingDidChange: Ember.observer 'contact.isUpdating', 'isUpdating', ->
    return unless @get('isUpdating')

    return unless @get('contact.isLead')
    return if @get('isPolling')

    @start()

  onPoll: ->
    return @stop() unless @get('isUpdating')

    contact = @get('contact')

    contact.one 'didReload', =>
      return @stop unless @get('isUpdating')

    contact.reload()

  stop: ->
    @_super.apply this, arguments
    clearInterval(@_timeout) if (@_timeout)

  finishSync: ->
    @stop()

    return unless @get('isUpdating')

    contact = @get('contact')

    observer = =>
      return unless contact.get('inCleanState')

      contact.removeObserver 'currentState.stateName', observer

      contact.set 'updateStatus', 'updated'

      contact.one 'didUpdate', ->
        contact.reload()

      @get('store').commit()

    unless contact.get('inCleanState')
      contact.addObserver 'currentState.stateName', observer
    else
      observer()

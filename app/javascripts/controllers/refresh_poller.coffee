require 'mixins/controllers/timeout_poller_mixin'

Radium.RefreshPoller = Ember.Object.extend Radium.TimeoutPollerMixin,
  stop: ->
    @_super.apply this, arguments
    @set('controller.isSyncing', false)
    clearInterval(@_timeout) if (@_timeout)

  onPoll: ->
    unless currentUser = @get('controller.currentUser')
      return

    if currentUser.get('syncState') == 'finished'
      @get('controller.controllers.messages').onPoll()
      @finishSync()


    if currentUser.get('inCleanState')
      currentUser.reload()

    currentUser.one 'becameError', =>
      @stop()

  finishSync: ->
    @stop()

    currentUser = @get('controller.currentUser')

    observer = =>
      return unless currentUser.get('inCleanState')

      currentUser.removeObserver 'currentState.stateName', observer

      currentUser.set 'syncState', 'waiting'
      currentUser.set 'emailsImported', 0

      currentUser.one 'didUpdate', ->
        currentUser.reload()

      @get('controller.store').commit()

    unless currentUser.get('inCleanState')
      currentUser.addObserver 'currentState.stateName', observer
    else
      observer()

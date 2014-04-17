Radium.RefreshPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 1000
  timeOutInterval: 10000
  _timeout: null
  start: ->
    @_super.apply this, arguments

    @_timeout = setInterval(@finishSync.bind(this), @timeOutInterval)

  stop: ->
    @_super.apply this, arguments
    @set('controller.isSyncing', false)
    clearInterval(@_timeout) if (@_timeout)

  onPoll: ->
    unless currentUser = @get('controller.currentUser')
      return

    if currentUser.get('syncState') == 'finished'
      @get('controller.container').lookup('route:messages').refresh()
      @finishSync()


    if currentUser.get('currentState.stateName') == "root.loaded.saved"
      currentUser.reload()

    currentUser.one 'becameError', =>
      @stop()

  finishSync: ->
    @stop()

    currentUser = @get('controller.currentUser')

    observer = =>
      return unless currentUser.get('currentState.stateName') == "root.loaded.saved"

      currentUser.removeObserver 'currentState.stateName', observer

      currentUser.set 'syncState', 'waiting'
      currentUser.set 'emailsImported', 0

      @get('controller.store').commit()

    if currentUser.get('currentState.stateName') != "root.loaded.saved"
      currentUser.addObserver 'currentState.stateName', observer
    else
      observer()

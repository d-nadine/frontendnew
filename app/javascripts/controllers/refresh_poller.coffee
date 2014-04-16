Radium.RefreshPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 1000
  timeOutInterval: 10000
  _timeout: null
  start: ->
    @_super.apply this, arguments

    @_timeout = setInterval(@_refreshTimedOut.bind(this), @timeOutInterval)

  stop: ->
    @_super.apply this, arguments
    clearInterval(@_timeout) if (@_timeout)

  onPoll: ->
    unless currentUser = @get('currentUser')
      return

    unless currentUser.get('isSyncing')
      @get('container').lookup('route:messages').refresh()
      @stop()

    currentUser.reload()

    currentUser.one 'becameError', =>
      @stop()

  _refreshTimedOut: ->
    @stop()

    currentUser = @get('currentUser')

    currentUser.set 'syncState', 'waiting'
    currentUser.set 'emailsImported', 0

    @get('store').commit()

Radium.RefreshPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 1000
  onPoll: ->
    unless currentUser = @get('currentUser')
      return

    unless currentUser.get('isSyncing')
      @stop()

    currentUser.reload()

    currentUser.one 'becameError', =>
      @stop()

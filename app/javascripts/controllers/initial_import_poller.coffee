Radium.InitialImportPoller = Ember.Object.extend Radium.PollerMxin,
  interval: 10000

  onPoll: ->
    currentUser = @get('currentUser')
    Ember.assert "You need to pass set currentUser on the InitialImportPoller", currentUser

    Radium.User.find({user_id: currentUser.get('id')}).then (users) =>
      console.log "Mail still importing"
      @stop() if users.get('firstObject.initialMailImported')

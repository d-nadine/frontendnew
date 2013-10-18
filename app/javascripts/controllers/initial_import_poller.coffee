Radium.InitialImportPoller = Ember.Object.extend Radium.PollerMixin,
  needs: ['messagesSidebar']
  interval: 1000

  onPoll: ->
    currentUser = @get('currentUser')
    Ember.assert "You need to pass set currentUser on the InitialImportPoller", currentUser

    @get('controllers.messagesSidebar').send 'showMore'

    Radium.User.find({user_id: currentUser.get('id')}).then (users) =>
      @stop() if users.get('firstObject.initialMailImported')

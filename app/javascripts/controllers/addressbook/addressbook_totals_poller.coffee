Radium.AddressbookTotalsPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 10000

  onPoll: ->
    currentUser = @get('currentUser')
    controller = @get('controller')

    Ember.assert 'must supply current user', currentUser
    Ember.assert 'must supply a controller', controller

    controller.send 'updateTotals'

    currentUser.one 'didReoload', =>
      @stop() if currentUser.get('initialContactsImported')

    currentUser.reload()

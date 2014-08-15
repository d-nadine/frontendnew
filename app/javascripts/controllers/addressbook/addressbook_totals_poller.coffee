Radium.AddressbookTotalsPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 5000
  contacts: 0
  companies: 0
  untracked: 0

  onPoll: ->
    Ember.assert 'must supply current user', @get('currentUser')
    userId = @get('currentUser.id')

    Radium.AddressbookTotals.find({}).then (results) =>
      result = results.get('firstObject')

      @setProperties result.get('data')

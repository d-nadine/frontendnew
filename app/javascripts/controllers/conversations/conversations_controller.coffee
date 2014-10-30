Radium.ConversationsController = Radium.ArrayController.extend
  actions:
    updateTotals: ->
      Radium.ConversationsTotals.find({}).then (results) =>
        totals = results.get('firstObject')

        @set 'incoming', totals.get('incoming')
        @set 'waiting', totals.get('waiting')
        @set 'later', totals.get('later')
        @set 'totalsLoading', false

  needs: ['users']
  itemController: 'conversationsItem'
  conversationType: null

  isIncoming: Ember.computed.equal "conversationType", "incoming"
  isWaiting: Ember.computed.equal "conversationType", "waiting"
  isLater: Ember.computed.equal "conversationType", "later"
  isReplied: Ember.computed.equal "conversationType", "replied"
  isArchived: Ember.computed.equal "conversationType", "archived"
  isIgnored: Ember.computed.equal "conversationType", "ignored"

  users: Ember.computed.alias 'controllers.users'

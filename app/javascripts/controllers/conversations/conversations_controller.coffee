Radium.ConversationsController = Radium.ArrayController.extend
  actions:
    updateTotals: ->
      Radium.ConversationsTotals.find({}).then (results) =>
        totals = results.get('firstObject')

        @set 'incoming', totals.get('incoming')
        @set 'waiting', totals.get('waiting')
        @set 'later', totals.get('later')

  needs: ['users']
  itemController: 'conversationsItem'
  conversationType: null
  users: Ember.computed.alias 'controllers.users'

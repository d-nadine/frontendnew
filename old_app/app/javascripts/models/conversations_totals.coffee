Radium.ConversationsTotals = Radium.Model.extend
  incoming: DS.attr('number')
  replied: DS.attr('number')
  waiting: DS.attr('number')
  later: DS.attr('number')
  allUsersTotals: DS.attr('number')
  usersTotals: DS.attr('array')
  sharedTotals: DS.attr('array')

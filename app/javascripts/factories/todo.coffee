# TODO: overdue should be dynamic
Factory.define 'todo', traits: 'timestamps',
  kind: 'general'
  description: Factory.sequence (i) -> "Todo #{i}"
  finishBy: -> Ember.DateTime.create().advance(days: 7)
  finished: false
  overdue: false

Factory.define 'overdueTodo', from: 'todo',
  finishBy: -> Ember.DateTime.create().advance(days: -7)
  overdue: true

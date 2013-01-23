# TODO: overdue should be dynamic
Factory.define 'todo', traits: 'timestamps',
  kind: 'general'
  description: Factory.sequence (i) -> "Todo #{i}"
  finish_by: -> Ember.DateTime.create().advance(day: 7).toFullFormat()
  finished: false
  overdue: false
  calendar_time: -> @finish_by

Factory.define 'overdueTodo', from: 'todo',
  finish_by: -> Ember.DateTime.create().advance(day: -7).toFullFormat()
  overdue: true

# TODO: overdue should be dynamic
Factory.define 'todo', traits: 'timestamps',
  kind: 'general'
  description: Factory.sequence (i) -> "Todo #{i}"
  finish_by: -> Ember.DateTime.create().advance(days: 7).toFullFormat()
  finished: false
  overdue: false
  calendar_time: -> @finish_by
  user_id: -> Factory.build 'user'

Factory.define 'overdueTodo', from: 'todo',
  finish_by: -> Ember.DateTime.create().advance(days: -7).toFullFormat()
  overdue: true

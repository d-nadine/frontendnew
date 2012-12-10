# TODO: overdue should be dynamic
Factory.define 'todo', traits: 'timestamps',
  kind: 'general'
  finish_by: -> Ember.DateTime.create().advance(days: 7).toFullFormat()
  overdue: false
  calendar_time: -> @finish_by
  user: -> Factory.build 'user'

Factory.define 'overdueTodo', from: 'todo',
  finish_by: -> Ember.DateTime.create().advance(days: -7).toFullFormat()
  overdue: true


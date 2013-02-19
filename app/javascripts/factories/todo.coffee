# TODO: overdue should be dynamic
Factory.define 'todo', traits: 'timestamps',
  kind: 'general'
  description: Factory.sequence (i) -> "Todo #{i}"
  finishBy: Ember.DateTime.create().advance(days: 7)
  finished: false
  user: -> Factory.create 'user'

Factory.define 'call', traits: 'timestamps',
  kind: 'call'
  description: -> Dictionaries.callDescriptions.random()
  finishBy: Ember.DateTime.create().advance(days: 7)
  reference: -> Factory.create('contact')

Factory.define 'overdueTodo', from: 'todo',
  finishBy: -> Ember.DateTime.create().advance(days: -7)

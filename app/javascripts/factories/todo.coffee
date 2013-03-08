# TODO: overdue should be dynamic
Factory.define 'todo', traits: 'timestamps',
  kind: 'general'
  description: Factory.sequence (i) -> "Todo #{i}"
  finishBy: -> Ember.DateTime.random()
  finished: false
  user: -> Factory.create 'user'
  isEditable: true

Factory.define 'call', traits: 'timestamps', from: 'todo',
  kind: 'call'
  description: -> Dictionaries.callDescriptions.random()
  reference: -> Factory.create('contact')
  isEditable: true

Factory.define 'overdueTodo', from: 'todo',
  isFinished: false
  finishBy: -> Ember.DateTime.random past: true
  isEditable: true

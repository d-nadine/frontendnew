Factory.define 'reminder', traits: 'timestamps',
  reference:
    id: -> Factory.build 'todo'
    type: 'todo'
  time: -> Ember.DateTime.create().advance(month: -1).toFullFormat()


Factory.define 'call', traits: 'timestamps',
  contact: -> Factory.create('contact')
  finishBy: -> Ember.DateTime.random()
  finished: false
  user: -> Factory.create 'user'
  isEditable: true

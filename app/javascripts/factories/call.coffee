Factory.define 'call', traits: 'timestamps',
  kind: 'call'
  description: -> Dictionaries.callDescriptions.random()
  reference: -> Factory.create('contact')
  finishBy: -> Ember.DateTime.random()
  finished: false
  user: -> Factory.create 'user'
  isEditable: true



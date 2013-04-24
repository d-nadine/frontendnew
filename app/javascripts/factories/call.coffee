Factory.define 'call', traits: 'timestamps',
  description: -> Dictionaries.callDescriptions.random()
  reference: -> Factory.create('contact')
  finishBy: -> Ember.DateTime.random()
  finished: false
  user: -> Factory.create 'user'
  isEditable: true



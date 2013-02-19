Factory.define 'deal', traits: 'timestamps',
  status: 'pending'
  name: 'Great deal'
  payBy: -> @createdAt.advance(month: 1)
  contact: -> Factory.create 'contact'
  value: -> Math.floor(Math.random() * 10000)
  createdAt: -> Ember.DateTime.random past: true
  reason: -> Dictionaries.failureReasons.random()
  status: -> Dictionaries.dealStatuses.random()
  isPublic: -> Math.random() <= 0.15
  lastStatus: ->
    if @status is 'lost'
      Dictionaries.dealStatuses.random()

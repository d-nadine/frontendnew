Factory.define 'deal', traits: 'timestamps',
  name: Factory.sequence (i) -> "Deal #{i}"
  payBy: -> @createdAt.advance(month: 1)
  contact: -> Factory.create 'contact'
  value: -> Math.floor(Math.random() * 10000)
  createdAt: -> Ember.DateTime.random past: true
  reason: -> Dictionaries.failureReasons.random()
  status: -> Dictionaries.dealStates.random()
  isPublic: -> Math.random() >= 0.25
  description: """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. In a tempus
    felis. Maecenas lacinia risus pellentesque ipsum vehicula convallis.
    Aenean lobortis erat in felis semper quis posuere sapien fermentum.
    Suspendisse metus tellus, sodales a ultrices ut, mattis vitae erat.
  """
  lastStatus: ->
    if @status is 'lost'
      Dictionaries.dealStates.random()
  checklist: -> Factory.create 'checklist'

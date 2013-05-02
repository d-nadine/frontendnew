Factory.define 'user', traits: ['timestamps'],
  firstName: -> Dictionaries.firstNames.random()
  lastName: -> Dictionaries.lastNames.random()
  email: Factory.sequence (i) -> "user#{i}@example.com"
  title: -> Dictionaries.titles.random()
  settings: ->
    signature: null

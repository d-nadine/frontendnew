Factory.define 'user', traits: ['timestamps'],
  firstName: -> Dictionaries.firstNames.random()
  lastName: -> Dictionaries.lastNames.random()
  title: -> Dictionaries.titles.random()
  email: Factory.sequence (i) -> "user#{i}@example.com"
  phone: "+934728783"
  salesGoal: -> Math.floor(Math.random() * 10000)
  settings: ->
    signature: null

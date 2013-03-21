Factory.define 'user', traits: ['timestamps'],
  name: "#{Dictionaries.firstNames.random()} #{Dictionaries.lastNames.random()}"
  email: Factory.sequence (i) -> "user#{i}@example.com"
  title: -> Dictionaries.titles.random()
  settings: ->
    signature: "#{@name}\n#{@title}"

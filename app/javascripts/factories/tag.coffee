Factory.define 'tag', traits: 'timestamps',
  name: -> Dictionaries.tags.random()
  description: -> "This tag is about #{@name}"
  user: -> Factory.create 'user'

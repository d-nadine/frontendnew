Factory.define 'tag', traits: 'timestamps',
  name: -> Dictionaries.tags.random()

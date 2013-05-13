Factory.define 'team', traits: 'timestamps',
  name: -> Dictionaries.teams.random()

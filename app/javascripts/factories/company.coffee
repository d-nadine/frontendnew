Factory.define 'company', traits: 'timestamps',
  name: -> Dictionaries.companies.random()

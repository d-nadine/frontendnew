Factory.define 'group', traits: 'timestamps',
  name: -> Dictionaries.companies.random()
  address: -> Factory.create 'address'

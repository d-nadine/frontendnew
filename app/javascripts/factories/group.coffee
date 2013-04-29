Factory.define 'group', traits: 'timestamps',
  name: -> Dictionaries.groups.random()
  address: -> Factory.create 'address'

Factory.define 'address', traits: 'timestamps',
  street: -> Dictionaries.streets.random()
  state: -> Dictionaries.states.random()
  country: -> Dictionaries.countries.random()
  zipcode: -> Dictionaries.zipcodes.random()

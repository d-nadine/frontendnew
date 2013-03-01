Factory.define 'group', traits: 'timestamps',
  name: -> "#{Dictionaries.companies.random()}"
  street: -> "#{Dictionaries.streets.random()}"
  state: -> "#{Dictionaries.states.random()}"
  country: -> "#{Dictionaries.countries.random()}"
  zipcode: -> "#{Dictionaries.zipcodes.random()}"

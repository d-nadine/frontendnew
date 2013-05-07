Factory.define 'company', traits: 'timestamps',
  name: -> Dictionaries.companies.random()
  address: -> Factory.create 'address'
  # website: -> "#{@name.replace(/\s/, '-')}.com".toLowerCase()

  addresses: -> [
    Factory.create 'address',
      name: 'Office'
      isPrimary: true
  ]

  tags: -> [
    Factory.create 'tag',
      name: Dictionaries.tags.random()
  ]



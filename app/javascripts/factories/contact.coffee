require 'factories/user'
require 'factories/phone_number'

Factory.define 'contact', traits: ['timestamps'],
  name: -> "#{Dictionaries.firstNames.random()} #{Dictionaries.lastNames.random()}"
  source: -> Dictionaries.leadSources.random()
  title: -> Dictionaries.titles.random()
  status: -> Dictionaries.leadStatuses.random()
  company: ->
    Factory.create 'company',
      name: Dictionaries.companies.random()

  user: -> Factory.create 'user'

  phoneNumbers: -> [
    Factory.create 'phoneNumber'
    Factory.create 'phoneNumber',
      name: "Work"
      value: "+934728783"
    Factory.create 'phoneNumber',
      name: "Home"
      value: "+35832478388"
  ]

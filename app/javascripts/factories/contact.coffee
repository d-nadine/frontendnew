require 'factories/user'

Factory.define 'contact', traits: ['timestamps'],
  name: -> "#{Dictionaries.firstNames.random()} #{Dictionaries.lastNames.random()}"
  source: -> Dictionaries.leadSources.random()
  title: -> Dictionaries.titles.random()
  status: -> Dictionaries.leadStatuses.random()
  company: -> Dictionaries.companies.random()

  user: -> Factory.create 'user'

  phoneNumbers: [
    { name: "Mobile", number: "+1348793247" }
    { name: "Work", number: "+934728783" }
    { name: "Home", number: "+35832478388" }
  ]

require 'factories/user'

Factory.define 'contact', traits: ['timestamps'],
  name: -> "#{Dictionaries.firstNames.random()} #{Dictionaries.lastNames.random()}"
  source: -> Dictionaries.leadSources.random()
  title: -> Dictionaries.titles.random()
  status: -> Dictionaries.leadStatuses.random()
  company: ->
    Factory.create 'company',
      name: Dictionaries.companies.random()

  user: -> Factory.create 'user'

  phoneNumbers: [
    { name: "Mobile", value: "+1348793247" }
    { name: "Work", value: "+934728783" }
    { name: "Home", value: "+35832478388" }
  ]

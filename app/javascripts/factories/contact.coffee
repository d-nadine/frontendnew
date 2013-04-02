require 'factories/user'

Factory.define 'contact', traits: ['timestamps'],
  name: -> "#{Dictionaries.firstNames.random()} #{Dictionaries.lastNames.random()}"
  isLead: -> Math.random() <= 0.30
  source: -> Dictionaries.leadSources.random()
  title: -> Dictionaries.titles.random()

  user: -> Factory.create 'user'

  phoneNumbers: [
    { name: "Mobile", number: "+1348793247" }
    { name: "Work", number: "+934728783" }
    { name: "Home", number: "+35832478388" }
  ]

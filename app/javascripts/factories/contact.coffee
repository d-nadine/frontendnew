require 'factories/user'

Factory.define 'contact', traits: ['timestamps'],
  name: Factory.sequence (i) -> "Contact #{i}"
  status: 'prospect'
  user: -> Factory.build 'user'

  phoneNumbers: [
    { name: "Mobile", number: "+1348793247" }
    { name: "Work", number: "+934728783" }
    { name: "Home", number: "+35832478388" }
  ]

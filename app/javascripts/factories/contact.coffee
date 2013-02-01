require 'radium/factories/user'

Factory.define 'contact', traits: ['timestamps'],
  name: Factory.sequence (i) -> "Contact #{i}"
  status: 'prospect'
  user: -> Factory.build 'user'

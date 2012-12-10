Factory.define 'contact', traits: ['timestamps'],
  status: 'prospect'
  user: -> Factory.build 'user'

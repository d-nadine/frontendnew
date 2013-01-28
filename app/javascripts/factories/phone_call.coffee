Factory.define 'phone_call', traits: 'timestamps',
  to: -> Factory.build 'user'
  from: -> Factory.build 'contact'

Factory.define 'phone_call', traits: 'timestamps',
  to:
    id: -> Factory.build 'user'
    type: 'user'
  from:
    id: -> Factory.build 'user'
    type: 'contact'

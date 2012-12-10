Factory.define 'phone_call', traits: 'timestamps',
  to:
    id: '2'
    type: 'user'
  from:
    id: '1'
    type: 'contact'

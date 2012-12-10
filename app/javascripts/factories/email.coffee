Factory.define 'email', traits: 'timestamps',
  subject: Factory.sequence (i) -> "Email #{i}"
  sender:
    id: -> Factory.build 'user'
    type: 'user'

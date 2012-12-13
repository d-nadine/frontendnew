Factory.define 'call_list', traits: 'timestamps',
  description: Factory.sequence (i) -> "Call List #{i}"
  user: -> Factory.build 'user'


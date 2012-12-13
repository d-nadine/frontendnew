Factory.define 'call_list', traits: 'timestamps',
  description: Factory.sequence (i) -> "Call List #{i}"
  user: -> Factory.build 'user'
  _associatedUserIds: -> [
    Factory.build('user').id,
    Factory.build('user').id
  ]

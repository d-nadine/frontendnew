Factory.define 'Todo', traits: 'timestamps',
  kind: 'general'
  overdue: false
  user: -> Factory.build 'user'

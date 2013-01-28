Factory.define 'notification', traits: 'timestamps',
  reference: -> Factory.build 'todo'
  tag: 'assigned.todo'


Factory.define 'notification', traits: 'timestamps',
  reference:
    id: -> Factory.build 'todo'
    type: 'todo'
  tag: 'assigned.todo'


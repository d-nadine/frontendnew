Factory.define 'notification', traits: 'timestamps',
  tag: 'assigned.todo'
  reference:
    id: -> Factory.build 'todo'
    type: 'todo'


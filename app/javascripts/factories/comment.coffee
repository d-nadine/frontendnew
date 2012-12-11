Factory.define 'comment', traits: 'timestamps',
  text: 'I like product drafts'
  commentable:
    id: -> Factory.build 'todo'
    type: 'todo'
  user: -> Factory.build 'user'

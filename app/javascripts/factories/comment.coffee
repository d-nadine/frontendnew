Factory.define 'comment', traits: 'timestamps',
  text: 'I like product drafts'
  commentable:
    id: 1
    type: 'todo'
  user: -> Factory.build 'user'

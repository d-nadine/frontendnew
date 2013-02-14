Factory.define 'comment', traits: 'timestamps',
  text: 'I like product drafts'
  user: -> Factory.build 'user'

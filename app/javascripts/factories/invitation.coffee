Factory.define 'invitation', traits: 'timestamps',
  meeting: Factory.build('meeting')
  user: -> Factory.build('user')


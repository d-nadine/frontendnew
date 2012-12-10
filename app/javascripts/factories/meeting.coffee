Factory.define 'meeting', traits: 'timestamps',
  starts_at: '2012-08-17T18:27:32Z'
  ends_at: '2012-08-18T18:27:32Z'
  topic: 'Product discussion'
  location: 'Radium HQ'
  user_id: -> Factory.build 'user'
  user_ids: -> [
    Factory.build 'user',
    Factory.build 'user'
  ]

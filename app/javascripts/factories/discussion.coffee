Factory.define 'discussion', traits: 'timestamps',
  topic: 'deal discussion'
  sentAt: -> Ember.DateTime.random()
  user: -> Factory.build 'user'
  attachments: -> [
    Factory.create 'attachment'
  ]


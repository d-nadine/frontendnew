# TODO: this changes should be done only
#       for API adapter, in FixtureAdapter
#       we could just use resulting keys
Radium.Adapter = DS.FixtureAdapter.extend()

Radium.Adapter.map 'Radium.Meeting',
  users: { key: 'user_ids' }

Radium.Adapter.map 'Radium.Notification',
  referenceData: { key: 'reference' }

Radium.Adapter.map 'Radium.Todo',
  referenceType: { key: 'reference.type' }

Radium.Adapter.map 'Radium.Person',
  phoneCalls: { key: 'phone_calls' }

Radium.Adapter.map 'Radium.FeedSection',
  items: { key: 'item_ids' }

Radium.Adapter.map 'Radium.FeedSection',
  user: { key: 'user_id' }

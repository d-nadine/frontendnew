Factory.trait 'timestamps',
  created_at: -> Ember.DateTime.create().advance(days: -2).toFullFormat()
  updated_at: -> Ember.DateTime.create().advance(days: -1).toFullFormat()

Factory.trait 'avatar',
  avatar:
    small_url: '/images/fallback/small_default.png'
    medium_url: '/images/fallback/medium_default.png'
    large_url: '/images/fallback/large_default.png'
    huge_url: '/images/fallback/huge_default.png'

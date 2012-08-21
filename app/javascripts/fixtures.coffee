Radium.FeedSection.FIXTURES = [
  {
    # I'm not sure yet how to handle feed sections, as they will
    # not be persisted in the database. Since all of the records should
    # have id, we may just generate random uuids for now.
    # This will matter the most when we will need to add more features to feed
    # (like scrolling), so I would like to reveisit then when I have more info
    id: '123-abc-def'
    # I don't have any good idea on how to populate items array without
    # overwriting HasMany associations to update it whenever association
    # changes. This will take some time, so for now I'll leave it like this,
    # directly giving feed section what it needs
    item_ids: [[Radium.Todo, 1]]
  }
]

Radium.Todo.FIXTURES = [
  {
    'id': 1
    'created_at': '2012-08-14T18:27:32Z'
    'updated_at': '2012-08-14T18:27:32Z'
    'user_id': 1
    'kind': 'general'
    'description': 'Finish first product draft'
    'finish_by': '2012-08-14T22:00:00Z'
    'finished': false
    'calendar_time': '2012-08-14T22:00:00Z'
    'overdue': false
  }
]

Radium.User.FIXTURES = [
  {
    'id': 1
    'created_at': '2012-06-23T17:44:53Z'
    'updated_at': '2012-07-03T11:32:57Z'
    'name': 'Aaron Stephens'
    'email': 'aaron.stephens13@feed-demo.com'
    'phone': '136127245078'
    'public': true
    'avatar':
      'small_url': '/images/fallback/small_default.png'
      'medium_url': '/images/fallback/medium_default.png'
      'large_url': '/images/fallback/large_default.png'
      'huge_url': '/images/fallback/huge_default.png'
    'account': 1
  }
]

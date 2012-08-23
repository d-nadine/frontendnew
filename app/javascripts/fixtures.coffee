Radium.FeedSection.FIXTURES = [
  {
    # TODO: think about the best way to handle id and lack of persistance here
    id: '2012-08-14'
    date: '2012-08-14T00:00:00Z'
    # I don't have any good idea on how to populate items array without
    # overwriting HasMany associations to update it whenever association
    # changes. This will take some time, so for now I'll leave it like this,
    # directly giving feed section what it needs
    item_ids: [
      [Radium.Todo, 1]
      [Radium.Meeting, 1]
      [Radium.Deal, 1]
      [Radium.CallList, 1]
      [Radium.Todo, 3]
      [Radium.Campaign, 1]
    ]
  }, {
    # TODO: think about the best way to handle id and lack of persistance here
    id: '2012-08-17'
    date: '2012-08-17T00:00:00Z'
    item_ids: [[Radium.Todo, 2]]
  }
]

Radium.CallList.FIXTURES = [
  {
    'id': 1
    'created_at': '2012-08-14T15:27:32Z'
    'updated_at': '2012-08-14T15:27:32Z'
    'user_id': 1
    'description': 'Call list'
  }
]

Radium.Deal.FIXTURES = [
  {
    'id': 1
    'created_at': '2012-08-14T15:27:32Z'
    'updated_at': '2012-08-14T15:27:32Z'
    'user_id': 1
    'state': 'pending'
    'close_by': '2012-08-17T18:27:32Z'
    'name': 'Great deal'
  }
]

Radium.Meeting.FIXTURES = [
  {
    'id': 1
    'created_at': '2012-08-17T18:27:32Z'
    'updated_at': '2012-08-17T18:27:32Z'
    'user_id': 2
    'user_ids': [1, 2]
    'starts_at': '2012-08-17T18:27:32Z'
    'ends_at': '2012-08-18T18:27:32Z'
    'topic': 'Product discussion'
    'location': 'Radium HQ'
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
    'comment_ids': [1]
  },  {
    'id': 2
    'created_at': '2012-08-17T18:27:32Z'
    'updated_at': '2012-08-17T18:27:32Z'
    'user_id': 2
    'kind': 'general'
    'description': 'Prepare product presentation'
    'finish_by': '2012-08-17T22:00:00Z'
    'finished': false
    'calendar_time': '2012-08-17T22:00:00Z'
    'overdue': false
  },  {
    'id': 3
    'created_at': '2012-08-17T18:27:32Z'
    'updated_at': '2012-08-17T18:27:32Z'
    'user_id': 1
    'kind': 'call'
    'contact_id': 1
    'description': 'discussing offer details'
    'finish_by': '2012-08-17T22:00:00Z'
    'finished': false
    'calendar_time': '2012-08-17T22:00:00Z'
    'overdue': false
  }
]

Radium.Contact.FIXTURES = [
  {
    'id': 1
    'display_name': 'Ralph'
    'status': 'prospect'
  }
]

Radium.Campaign.FIXTURES = [
  {
    'id': 1
    'name': 'Fall product campaign'
    'user_id': 1
  }
]

Radium.Comment.FIXTURES = [
  {
    'id': 1
    'created_at': '2012-06-23T17:44:53Z'
    'updated_at': '2012-07-03T11:32:57Z'
    'text': 'I like product drafts'
    'user_id': 1
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
  },  {
    'id': 2
    'created_at': '2012-06-23T17:44:53Z'
    'updated_at': '2012-07-03T11:32:57Z'
    'name': 'Jerry Parker'
    'email': 'jerry.parker@feed-demo.com'
    'phone': '136127245071'
    'public': true
    'avatar':
      'small_url': '/images/fallback/small_default.png'
      'medium_url': '/images/fallback/medium_default.png'
      'large_url': '/images/fallback/large_default.png'
      'huge_url': '/images/fallback/huge_default.png'
    'account': 2
  }
]

Factory.define 'Core',
  abstract: true
  defaults:
    created_at: '2012-08-14T18:27:32Z'
    updated_at: '2012-08-14T18:27:32Z'

Factory.define 'CallList',
  sequence: 'id'
  parent: 'Core'
  defaults:
    user_id: 1
    description: 'Call list'

Factory.define 'Deal',
  sequence: 'id'
  parent: 'Core'
  defaults:
    user_id: 1
    state: 'pending'
    close_by: '2012-08-17T18:27:32Z'
    name: 'Great deal'

Factory.build 'Deal', 'big_contract',
  name: 'Big contract'

Factory.build 'Deal', 'small_contract',
  name: 'Small contract'

Factory.define 'User',
  abstract: true
  sequence: 'id'
  defaults:
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    public: true
    avatar:
      small_url: '/images/fallback/small_default.png'
      medium_url: '/images/fallback/medium_default.png'
      large_url: '/images/fallback/large_default.png'
      huge_url: '/images/fallback/huge_default.png'

Factory.build 'User', 'aaron',
  name: 'Aaron Stephens'
  email: 'aaron.stephens13@feed-demo.com'
  phone: '136127245078'
  account: 1

Factory.build 'User', 'jerry',
  pdated_at: '2012-07-03T11:32:57Z'
  name: 'Jerry Parker'
  email: 'jerry.parker@feed-demo.com'
  phone: '136127245071'
  account: 2

Factory.define 'Contact',
  abstract: true
  parent: 'Core'
  sequence: 'id'
  defaults:
    status: 'prospect'

Factory.build 'Contact', 'ralph',
  display_name: 'Ralph'

Factory.build 'Contact', 'john',
  display_name: 'John'

Factory.define 'Meeting',
  sequence: 'id'
  parent: 'Core'
  defaults:
    user_id: 2
    user_ids: Factory.association('User', ['aaron', 'jerry'])
    starts_at: '2012-08-17T18:27:32Z'
    ends_at: '2012-08-18T18:27:32Z'
    topic: 'Product discussion'
    location: 'Radium HQ'

Factory.build 'Meeting','retrospection',
  topic: 'Retrospection'

Factory.define 'Comment',
  sequence: 'id'
  parent: 'Core'
  defaults:
    id: '1'
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    text: 'I like product drafts'
    user_id: 1
    commentable:
      id: 1
      type: 'todo'

Factory.define 'Todo',
  abstract: true
  parent: 'Core'
  sequence: 'id'
  defaults:
    user_id: 1
    kind: 'general'
    overdue: false

Factory.build 'Todo', 'default',
  description: 'Finish first product draft'
  finish_by: '2012-08-14T22:00:00Z'
  finished: false
  calendar_time: '2012-08-14T22:00:00Z'
  comment_ids: Factory.association('Comment', ['default'])

Factory.build 'Todo', 'overdue',
  user_id: 2
  description: 'Prepare product presentation'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'
  overdue: true

Factory.build 'Todo', 'call',
  kind: 'call'
  reference:
    id: '1'
    type: 'contact'
  description: 'discussing offer details'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'deal',
  kind: 'general'
  reference:
    id: '1'
    type: 'deal'
  description: 'Close the deal'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'campaign',
  kind: 'general'
  reference:
    id: '1'
    type: 'campaign'
  description: 'Prepare campaign plan'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'email',
  reference:
    id: '1'
    type: 'email'
  description: 'write a nice response'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'group',
  reference:
    id: '1'
    type: 'group'
  description: 'schedule group meeting'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'phone_call',
  reference:
    id: '1'
    type: 'phone_call'
  description: 'product discussion'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'sms',
  reference:
    id: '1'
    type: 'sms'
  description: 'product discussion'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'with_todo',
  reference:
    id: '1'
    type: 'todo'
  description: 'inception'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'call_ralph',
  kind: 'call'
  reference:
    id: '1'
    type: 'contact'
  description: 'discussing offer details'
  finish_by: '2012-08-17T22:00:00Z'
  finished: false
  calendar_time: '2012-08-17T22:00:00Z'

Factory.build 'Todo', 'finish_by_tomorrow',
  description: 'Buy office equipment'
  finish_by: "#{Ember.DateTime.create().advance(day: 1).toFormattedString('%Y-%m-%d')}T00:00:00Z"
  finished: false

Factory.define 'Campaign',
  sequence: 'id'
  parent: 'Core'
  defaults:
    name: 'Fall product campaign'
    user_id: 1

Factory.define 'Email',
  sequence: 'id'
  parent: 'Core'
  defaults:
    sender:
      id: '2'
      type: 'user'

Factory.define 'Group',
  sequence: 'id'
  parent: 'Core'
  defaults:
    name: 'Product 1 group'

Factory.build 'Group', 'developers',
  name: 'Developers'

Factory.define 'PhoneCall',
  sequence: 'id'
  parent: 'Core'
  defaults:
    to:
      id: '2'
      type: 'user'
    from:
      id: '1'
      type: 'contact'

Factory.define 'Sms',
  sequence: 'id'
  parent: 'Core'
  defaults:
    sender_id: 2

Factory.define 'Notification',
  abstract: true
  sequence: 'id'
  parent: 'Core'

# Not loading correctly, polymorphism?
Factory.build 'Notification', 'todo',
  reference:
    id: '1'
    type: 'todo'
  created_at: '2012-08-14T18:27:32Z'
  updated_at: '2012-08-14T18:27:32Z'
  tag: 'assigned.todo'

Factory.build 'Notification', 'meeting_invitation',
  reference:
    id: '1'
    type: 'invitation'
  created_at: '2012-08-14T18:27:32Z'
  updated_at: '2012-08-14T18:27:32Z'
  tag: 'invited.meeting'

Factory.define 'Invitation',
  abstract: true
  sequence: 'id'
  parent: 'Core'

Factory.build 'Invitation', 'for_meeting_1',
  user_id: 1
  meeting_id: 1

Factory.define 'Reminder',
  abstract: true
  sequence: 'id'
  parent: 'Core'

Factory.build 'Reminder', 'todo',
  time: '2012-08-14T18:27:32Z'
  reference:
    id: '1'
    type: 'todo'

Factory.build 'Reminder', 'meeting',
  time: '2012-08-14T18:27:32Z'
  reference:
    id: '1'
    type: 'meeting'

Factory.define 'Message',
  sequence: 'id'
  parent: 'Core'
  defaults:
    type: 'email'
    sentAt: '2012-08-14T18:27:32Z'
    message: 'Hey, what\'s up?'

Factory.define 'FeedSection',
  abstract: true
  defaults:
    item_ids: []

Factory.build 'FeedSection', 'default',
  id: '2012-08-14'
  date: '2012-08-14T00:00:00Z'
  # I don't have any good idea on how to populate items array without
  # overwriting HasMany associations to update it whenever association
  # changes. This will take some time, so for now I'll leave it like this,
  # directly giving feed section what it needs
  item_ids: [
    [Radium.Todo, 5]
    [Radium.Todo, 6]
    [Radium.Todo, 7]
    [Radium.Todo, 8]
    [Radium.Todo, 9]
    [Radium.Todo, 10]
    [Radium.Todo, 11]
    [Radium.Todo, 12]
    [Radium.Meeting, 1]
    [Radium.Deal, 1]
    [Radium.CallList, 1]
    [Radium.Campaign, 1]
  ]
  _associatedUserIds: [1]
  _associatedGroupIds: [1]

Factory.build 'FeedSection', 'feed_section_2012_08_17',
  id: '2012-08-17'
  date: '2012-08-17T00:00:00Z'
  item_ids: [
    [Radium.Todo, 1]
    [Radium.Todo, 2]
    [Radium.Todo, 3]
    [Radium.Todo, 4]
  ]
  _associatedContactIds: [1]
  _associatedUserIds: [1]

Factory.build 'FeedSection', 'feed_section_2012_07_15',
  id: '2012-07-15'
  date: '2012-07-15T00:00:00Z'
  item_ids: [[Radium.Meeting, 2]]

Factory.build 'FeedSection', 'feed_section_4',
  id: '2012-07-14'
  date: '2012-07-14T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_5',
  id: '2012-07-13'
  date: '2012-07-13T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_6',
  id: '2012-07-12'
  date: '2012-07-12T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_7',
  id: '2012-07-11'
  date: '2012-07-11T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_8',
  id: '2012-07-10'
  date: '2012-07-10T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_9',
  id: '2012-07-09'
  date: '2012-07-09T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_10',
  id: '2012-07-08'
  date: '2012-07-08T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_11',
  id: '2012-07-07'
  date: '2012-07-07T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_12',
  id: '2012-07-06'
  date: '2012-07-06T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'feed_section_13',
  id: '2012-07-05'
  date: '2012-07-05T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'section_2012_08_31',
  id: '2012-08-31'
  date: '2012-08-31T00:00:00Z'
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'today',
  id: Ember.DateTime.create().toFormattedString('%Y-%m-%d')
  date: "#{Ember.DateTime.create().toFormattedString('%Y-%m-%d')}T00:00:00Z"
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'tomorrow',
  id: Ember.DateTime.create().advance(day: 1).toFormattedString('%Y-%m-%d')
  date: "#{Ember.DateTime.create().advance(day: 1).toFormattedString('%Y-%m-%d')}T00:00:00Z"
  item_ids: [[Radium.Deal, 3]]

Factory.build 'FeedSection', 'week_from_now',
  id: Ember.DateTime.create().advance(day: 7).toFormattedString('%Y-%m-%d')
  date: "#{Ember.DateTime.create().advance(day: 7).toFormattedString('%Y-%m-%d')}T00:00:00Z"
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'two_weeks_from_now',
  id: Ember.DateTime.create().advance(day: 14).toFormattedString('%Y-%m-%d')
  date: "#{Ember.DateTime.create().advance(day: 14).toFormattedString('%Y-%m-%d')}T00:00:00Z"
  item_ids: [[Radium.Deal, 2]]

Factory.build 'FeedSection', 'month_from_now',
  id: Ember.DateTime.create().advance(month: 1).toFormattedString('%Y-%m-%d')
  date: "#{Ember.DateTime.create().advance(month: 1).toFormattedString('%Y-%m-%d')}T00:00:00Z"
  item_ids: [[Radium.Deal, 2], [Radium.Todo, 11]]
  _associatedContactIds: [1]

for i in [1..200]
  date = Ember.DateTime.create().advance(day: 100 + i)
  Factory.build 'FeedSection', "additional_feed_section_in_future_#{i}",
    id: date.toFormattedString('%Y-%m-%d')
    date: "#{date.toFormattedString('%Y-%m-%d')}T00:00:00Z"
    item_ids: [
      [Radium.Deal, 2]
      [Radium.Todo, 8]
      [Radium.Todo, 9]
      [Radium.Todo, 10]
      [Radium.Meeting, 1]
      [Radium.Deal, 1]
      [Radium.CallList, 1]
      [Radium.Campaign, 1]
    ]

Radium.Gap.FIXTURES = []


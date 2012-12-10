Factory.adapter = new Factory.RadiumAdapter(Radium.get('router.store'))

aaron = Factory.create 'user',
  name: 'Aaron Stephens'
  email: 'aaron.stephens13@feed-demo.com'
  phone: '136127245078'

jerry = Factory.create 'user'
  name: 'Jerry Parker'
  email: 'jerry.parker@feed-demo.com'
  phone: '136127245071'

ralph = Factory.create 'contact',
  display_name: 'Ralph'

john = Factory.create 'contact'
  display_name: 'John'

retrospection = Factory.create 'meeting',
  topic: 'Retrospection'

# todo = Factory.create 'todo',
#   description: 'Finish first product draft'

# overdueTodo = Factory.create 'overdueTodo',
#   user: jerry,
#   description: 'Prepare product presentation'

# Factory.build 'Todo', 'call',
#   kind: 'call'
#   reference:
#     id: '1'
#     type: 'contact'
#   description: 'discussing offer details'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'deal',
#   kind: 'general'
#   reference:
#     id: '1'
#     type: 'deal'
#   description: 'Close the deal'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'campaign',
#   kind: 'general'
#   reference:
#     id: '1'
#     type: 'campaign'
#   description: 'Prepare campaign plan'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'email',
#   reference:
#     id: '1'
#     type: 'email'
#   description: 'write a nice response'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'group',
#   reference:
#     id: '1'
#     type: 'group'
#   description: 'schedule group meeting'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'phone_call',
#   reference:
#     id: '1'
#     type: 'phone_call'
#   description: 'product discussion'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'sms',
#   reference:
#     id: '1'
#     type: 'sms'
#   description: 'product discussion'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'with_todo',
#   reference:
#     id: '1'
#     type: 'todo'
#   description: 'inception'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'call_ralph',
#   kind: 'call'
#   reference:
#     id: '1'
#     type: 'contact'
#   description: 'discussing offer details'
#   finish_by: '2012-08-17T22:00:00Z'
#   finished: false
#   calendar_time: '2012-08-17T22:00:00Z'

# Factory.build 'Todo', 'finish_by_tomorrow',
#   description: 'Buy office equipment'
#   finish_by: Ember.DateTime.create().advance(day: 1).toFullFormat()
#   finished: false


# Factory.build 'Group', 'developers',
#   name: 'Developers'


# # Not loading correctly, polymorphism?
# Factory.build 'Notification', 'todo',
#   reference:
#     id: '1'
#     type: 'todo'
#   created_at: '2012-08-14T18:27:32Z'
#   updated_at: '2012-08-14T18:27:32Z'
#   tag: 'assigned.todo'

# Factory.build 'Notification', 'meeting_invitation',
#   reference:
#     id: '1'
#     type: 'invitation'
#   created_at: '2012-08-14T18:27:32Z'
#   updated_at: '2012-08-14T18:27:32Z'
#   tag: 'invited.meeting'


# Factory.build 'Invitation', 'for_meeting_1',
#   user_id: 1
#   meeting_id: 1

# Factory.build 'Reminder', 'todo',
#   time: '2012-08-14T18:27:32Z'
#   reference:
#     id: '1'
#     type: 'todo'

# Factory.build 'Reminder', 'meeting',
#   time: '2012-08-14T18:27:32Z'
#   reference:
#     id: '1'
#     type: 'meeting'

# Factory.build 'FeedSection', 'default',
#   id: '2012-08-14'
#   date: '2012-08-14T00:00:00Z'
#   # I don't have any good idea on how to populate items array without
#   # overwriting HasMany associations to update it whenever association
#   # changes. This will take some time, so for now I'll leave it like this,
#   # directly giving feed section what it needs
#   item_ids: [
#     [Radium.Todo, 5]
#     [Radium.Todo, 6]
#     [Radium.Todo, 7]
#     [Radium.Todo, 8]
#     [Radium.Todo, 9]
#     [Radium.Todo, 10]
#     [Radium.Todo, 11]
#     [Radium.Todo, 12]
#     [Radium.Meeting, 1]
#     [Radium.Deal, 1]
#     [Radium.CallList, 1]
#     [Radium.Campaign, 1]
#   ]
#   _associatedUserIds: [1]
#   _associatedGroupIds: [1]

# Factory.build 'FeedSection', 'feed_section_2012_08_17',
#   id: '2012-08-17'
#   date: '2012-08-17T00:00:00Z'
#   item_ids: [
#     [Radium.Todo, 1]
#     [Radium.Todo, 2]
#     [Radium.Todo, 3]
#     [Radium.Todo, 4]
#   ]
#   _associatedContactIds: [1]
#   _associatedUserIds: [1]

# Factory.build 'FeedSection', 'feed_section_2012_07_15',
#   id: '2012-07-15'
#   date: '2012-07-15T00:00:00Z'
#   item_ids: [[Radium.Meeting, 2]]

# Factory.build 'FeedSection', 'feed_section_4',
#   id: '2012-07-14'
#   date: '2012-07-14T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_5',
#   id: '2012-07-13'
#   date: '2012-07-13T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_6',
#   id: '2012-07-12'
#   date: '2012-07-12T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_7',
#   id: '2012-07-11'
#   date: '2012-07-11T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_8',
#   id: '2012-07-10'
#   date: '2012-07-10T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_9',
#   id: '2012-07-09'
#   date: '2012-07-09T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_10',
#   id: '2012-07-08'
#   date: '2012-07-08T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_11',
#   id: '2012-07-07'
#   date: '2012-07-07T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_12',
#   id: '2012-07-06'
#   date: '2012-07-06T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'feed_section_13',
#   id: '2012-07-05'
#   date: '2012-07-05T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'section_2012_08_31',
#   id: '2012-08-31'
#   date: '2012-08-31T00:00:00Z'
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'today',
#   id: Ember.DateTime.create().toDateFormat()
#   date: Ember.DateTime.create().toFullFormat()
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'tomorrow',
#   id: Ember.DateTime.create().advance(day: 1).toDateFormat()
#   date: Ember.DateTime.create().advance(day: 1).toFullFormat()
#   item_ids: [[Radium.Deal, 3]]

# Factory.build 'FeedSection', 'week_from_now',
#   id: Ember.DateTime.create().advance(day: 7).toDateFormat()
#   date: Ember.DateTime.create().advance(day: 7).toFullFormat()
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'two_weeks_from_now',
#   id: Ember.DateTime.create().advance(day: 14).toDateFormat()
#   date: Ember.DateTime.create().advance(day: 14).toFullFormat()
#   item_ids: [[Radium.Deal, 2]]

# Factory.build 'FeedSection', 'month_from_now',
#   id: Ember.DateTime.create().advance(month: 1).toDateFormat()
#   date: Ember.DateTime.create().advance(month: 1).toFullFormat()
#   item_ids: [[Radium.Deal, 2], [Radium.Todo, 11]]
#   _associatedContactIds: [1]

# for i in [1..200]
#   date = Ember.DateTime.create().advance(day: 100 + i)
#   Factory.build 'FeedSection', "additional_feed_section_in_future_#{i}",
#     id: date.toDateFormat()
#     date: date.toFullFormat()
#     item_ids: [
#       [Radium.Deal, 2]
#       [Radium.Todo, 8]
#       [Radium.Todo, 9]
#       [Radium.Todo, 10]
#       [Radium.Meeting, 1]
#       [Radium.Deal, 1]
#       [Radium.CallList, 1]
#       [Radium.Campaign, 1]
#     ]

# Radium.Gap.FIXTURES = []


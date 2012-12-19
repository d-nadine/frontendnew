module 'Application Factories'

test 'builds a campaign with associations', ->
  campaign = Factory.create 'campaign',
    user: -> Factory.build 'user'

  equal campaign.get('id'), 1, 'campaign exists'
  ok campaign.get('user.isLoaded'), 'user is loaded'

test 'builds a user', ->
  user = Factory.create 'user'

  ok user.get('id'), 'ID exists'
  ok user.get('name'), 'Name exists'

test 'builds a todo', ->
  todo = Factory.create 'todo',
    user: -> Factory.build 'user'

  ok todo.get('id'), 'ID exists'

  ok todo.get('finishBy'), 'Finish by date exists'
  ok !todo.get('finished'), 'Todo not finished'

  ok todo.get('description'), 'Description exists'
  equal todo.get('kind'), 'general', 'Kind correct'

  ok !todo.get('overdue'), 'Todo is not overdue'

  ok todo.get('user.isLoaded'), 'user is loaded'

test 'builds a call list', ->
  callList = Factory.create 'call_list',
    user: -> Factory.build 'user'

  ok callList.get('id'), 'call list ID exists'
  equal "Call List 1", callList.get('description'), 'call list description set'
  ok callList.get('user.isLoaded'), 'call list user is loaded'

test 'builds a contact', ->
  contact = Factory.create 'contact'

  ok contact.get('isLoaded'), 'contact is loaded'

test 'builds a comment', ->
  comment = Factory.create 'comment',
    commentable:
      id: -> Factory.build 'todo'
      type: 'todo'
    user: -> Factory.build 'user'

  ok comment.get('isLoaded'), 'comment is loaded'
  ok comment.get('user.isLoaded'), 'user is loaded'
  ok comment.get('commentable.isLoaded'), 'polymorphic association added'
  equal comment.get('commentable.type'), 'todo', 'correct polymorphic type added'

test 'builds a deal', ->
  deal = Factory.create 'deal',
    user: -> Factory.build 'user'

  ok deal.get('isLoaded'), 'deal is loaded'
  ok deal.get('user.isLoaded'), 'user is loaded'

test 'builds an email', ->
  email = Factory.create 'email'

  ok email.get('isLoaded'), 'eamil is loaded'
  ok email.get('sender.isLoaded'), 'sender is loaded'

test 'build a feed section', ->
  feed_section = Factory.create 'feed_section',
    item_ids: [
      ['todo', Factory.build('todo')]
    ]

  ok feed_section.get('isLoaded'), 'FeedSection loaded'
  equal feed_section.get('items.length'), 1, 'Feed section items loaded'
  equal feed_section.get('items.firstObject').constructor, Radium.Todo, 'correct first item loaded'

test 'build a group section', ->
  group = Factory.create 'group'

  ok group.get('isLoaded'), 'group is loaded'

test 'build an invitation', ->
  invitation = Factory.create 'invitation',
    user: -> Factory.build 'user',
    meeting: -> Factory.build('meeting')

  ok invitation.get('isLoaded'), 'invitation is loaded'
  ok invitation.get('user.isLoaded'), 'user is loaded'
  ok invitation.get('meeting.isLoaded'), 'meeting is loaded'

test 'build a meeting', ->
  meeting = Factory.create 'meeting',
    user: -> Factory.build 'user'
    users: -> [
      Factory.build('user'),
      Factory.build('user')
    ]

  ok meeting.get('isLoaded'), 'meeting is loaded'
  equal meeting.get('users.length'), 2, 'meeting users loaded'

test 'build a notification', ->
  notification = Factory.create 'notification'

  ok notification.get('isLoaded'), 'notification is loaded'
  ok notification.get('reference.isLoaded'), 'notification reference is loaded'
  equal notification.get('reference.type'), 'todo', 'correct polymorphic type added'

test 'build a phone call', ->
  phone_call = Factory.create 'phone_call'

  ok phone_call.get('isLoaded'), 'phone call is loaded'
  ok phone_call.get('to.isLoaded'), 'phone call to is loaded'
  equal phone_call.get('to').constructor, Radium.User, 'phone call to type correct'
  ok phone_call.get('from.isLoaded'), 'phone call from is loaded'
  equal phone_call.get('from').constructor, Radium.Contact, 'phone call from type correct'

# test 'build a reminder', ->
#   reminder = Factory.create 'reminder'
#     reference:
#       id: -> Factory.build 'todo'
#       type: 'todo'
#     time: -> Ember.DateTime.create().advance(month: -1).toFullFormat()
# 
#   ok reminder.get('isLoaded'), 'reminder is loaded'
#   ok reminder.get('reference.isLoaded'), 'polymorphic added'
# 
test 'builds an sms', ->
  sms = Factory.create 'sms'

  ok sms.get('isLoaded'), 'sms is loaded'
  ok sms.get('sender.isLoaded'), 'sender is loaded'

# test 'builds a message', ->
#   message = Factory.create 'message'
# 
#   ok message.get('isLoaded'), 'message is loaed'

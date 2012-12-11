module 'Application Factories',
  setup: ->
    Factory.adapter.store = Radium.Store.create()

test 'builds a campaign with associations', ->
  campaign = Factory.create 'campaign'

  equal campaign.get('id'), 1, 'campaign exists'
  ok campaign.get('user.isLoaded'), 'user is loaded'

test 'builds a user', ->
  user = Factory.create 'user'

  ok user.get('id'), 'ID exists'
  ok user.get('name'), 'Name exists'

test 'builds a todo', ->
  todo = Factory.create 'todo'

  ok todo.get('id'), 'ID exists'

  ok todo.get('finishBy'), 'Finish by date exists'
  ok !todo.get('finished'), 'Todo not finished'

  ok todo.get('description'), 'Description exists'
  equal todo.get('kind'), 'general', 'Kind correct'

  ok !todo.get('overdue'), 'Todo is not overdue'

  ok todo.get('user.isLoaded'), 'user is loaded'
  ok todo.get('reference.isLoaded'), 'polymorphic added'

test 'builds a call list', ->
  callList = Factory.create 'call_list'

  ok callList.get('id'), 'call list ID exists'
  equal "Call List 1", callList.get('description'), 'call list description set'

test 'builds a contact', ->
  contact = Factory.create 'contact'

  ok contact.get('isLoaded'), 'contact is loaded'

test 'builds a comment', ->
  comment = Factory.create 'comment'

  ok comment.get('isLoaded'), 'comment is loaded'
  ok comment.get('user.isLoaded'), 'user is loaded'
  ok comment.get('commentable.isLoaded'), 'polymorphic association added'
  equal comment.get('commentable.type'), 'todo', 'correct polymorphic type added'

test 'builds a deal', ->
  deal = Factory.create 'deal'

  ok deal.get('isLoaded'), 'deal is loaded'
  ok deal.get('user.isLoaded'), 'user is loaded'

test 'builds an email', ->
  email = Factory.create 'email'

  ok email.get('isLoaded'), 'eamil is loaded'
  ok email.get('sender.isLoaded'), 'sender is loaded'





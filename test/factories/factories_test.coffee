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

  equal '1',  todo.get('user.id'), 'User set'

test 'builds a call list', ->
  callList = Factory.create 'call_list'

  ok callList.get('id'), 'call list ID exists'
  equal "Call List 1", callList.get('description'), 'call list description set'

test 'builds a campaign', ->
  campaign = Factory.create 'campaign'

  ok campaign.get('id'), 'call list ID exists'
  equal "Campaign 1", campaign.get('name'), 'campaign name'
  equal '1',  todo.get('user.id'), 'User set'

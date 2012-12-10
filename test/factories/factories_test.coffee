module 'Application Factories'

test 'builds a user', ->
  user = Factory.create 'user'

  ok user.get('id'), 'ID exists'
  ok user.get('name'), 'Name exists'

test 'builds a todo', ->
  debugger

  todo = Factory.create 'todo'

  ok todo.get('id'), 'ID exists'

  ok todo.get('finishBy'), 'Finish by date exists'
  ok !todo.get('finished'), 'Todo not finished'

  ok todo.get('description'), 'Description exists'
  equal todo.get('kind'), 'general', 'Kind correct'

  ok !todo.get('overdue'), 'Todo is not overdue'

  ok todo.get('user'), 'User set'

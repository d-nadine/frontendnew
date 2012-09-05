Fixtures.loadAll(now: true)

module 'Radium.Todo'

test 'reference property correctly sets reference.type and reference.id', ->
  todo = F.todos('default')
  meeting = F.meetings('default')

  Ember.run ->
    todo.set 'reference', meeting

  equal todo.get('reference'), meeting, ''
  equal todo.get('data.reference.id'), meeting.get('id'), ''
  equal todo.get('data.reference.type'), 'meeting', ''


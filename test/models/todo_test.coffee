module 'Radium.Todo'

test 'reference property correctly sets reference.type and reference.id', ->
  todo = F.todos('default')
  meeting = F.meetings('default')

  todo.set 'reference', meeting

  equal todo.get('referenceType'), 'meeting', ''
  equal todo.get('data.reference.id'), meeting.get('id'), ''


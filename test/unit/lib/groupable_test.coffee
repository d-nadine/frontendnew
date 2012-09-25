app('/')

test 'clustered record array behaves as regular array when dealing with it', ->
  content = Ember.A([])
  array = Em.ArrayProxy.create Radium.Groupable,
    groupBy: (item) ->
      item.get('foo')
    content: content

  equal array.get('length'), 0, 'there should be no groups at first'

  content.pushObject Em.Object.create(foo: 'foo')

  equal array.get('length'), 1, 'group should be created when an element is added'
  equal array.objectAt(0).get('groupId'), 'foo', 'group id should be set properly'

  content.pushObject Em.Object.create(foo: 'foo')

  equal array.get('length'), 1, 'no groups should be created if a group with given value already exists'

  bar = Em.Object.create(foo: 'bar')
  content.pushObject bar

  equal array.get('length'), 2, 'new group should be created when new element type is added'

  deepEqual array.map( (group) -> group.get('groupId') ).sort(), ['bar', 'foo'], ''

  content.removeObject bar

  equal array.get('length'), 1, 'group should be removed when there is no elements in the group'

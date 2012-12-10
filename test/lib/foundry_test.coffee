foundry = null

module 'foundry',
  setup: ->
    foundry = new Foundry()

  teardown: ->
    foundry.tearDown()

test 'raises exception for undefined foundry', ->
  raises (-> foundry.build('Unkown')), "must throw error for unkown definition"

test 'raise an error when redifining a foundry', ->
  foundry.define 'Contact'

  raises (-> foundry.define('Contact', {})), "Redifining must throw an error"

module 'foundry - default values',
  setup: ->
    foundry = new Foundry()

    foundry.define 'Contact',
      id: '1'
      display_name: 'Ralph'
      status: 'prospect'

  teardown: ->
    foundry.tearDown()

test 'should create a default object with default values', ->
  contact = foundry.build 'Contact'

  equal contact.id, '1'
  equal contact.display_name, 'Ralph'
  equal contact.status, 'prospect'

test 'default values can be overriden in new instance', ->
  contact = foundry.build 'Contact',
    id: 2
    display_name: 'Bob'

  equal contact.id, '2'
  equal contact.display_name, 'Bob'
  equal contact.status, 'prospect'

test 'attributes can be function', ->
  contact = foundry.build 'Contact', 
    company: -> 'Nokia'

  equal contact.company, 'Nokia'

test 'attribute functions have access to the object', ->
  contact = foundry.build 'Contact',
    name: 'Adam'
    email: -> "#{@name}@radiumcrm.com"

  equal contact.email, "Adam@radiumcrm.com"

test 'attribute can be nested', ->
  foundry.define 'ContactWithAddress', from: 'Contact',
    address:
      street: '123 Foo Bar'
      city: 'Baztown'

  contact = foundry.build 'ContactWithAddress',
    address:
      street: '456 Qux'

  equal contact.address.street, '456 Qux', 'Nested attributes override'
  equal contact.address.city, 'Baztown', 'Nested attributes maintained'

test 'function attributes can be nested', ->
  foundry.define 'ContactWithAddress', from: 'Contact',
    address:
      street: '123 Foo Bar'
      city: 'Baztown'

  contact = foundry.build 'ContactWithAddress',
    address:
      street: -> '456 Qux'

  equal contact.address.street, '456 Qux', 'Nested attributes override'
  equal contact.address.city, 'Baztown', 'Nested attributes maintained'

module 'foundry - Parent',
  setup: ->
    foundry = new Foundry()
    foundry.define 'Human',
      sex: 'Male'

  teardown: ->
    foundry.tearDown()

test 'a foundry can use a parent', ->
  foundry.define 'Adam', from: 'Human',
    name: 'Adam'

  adam = foundry.build 'Adam'

  equal adam.name, 'Adam', 'Defined attribute correct'
  equal adam.sex, 'Male', 'Parent attribute correct'

test 'a foundry can define a parent and extend its defaults', ->
  foundry.define 'Female', from: 'Human',
    sex: 'Female'

  female = foundry.build 'Female'

  equal female.sex, 'Female', 'Parent attribute redefined'

module 'foundry - sequence',
  setup: ->
    foundry = new Foundry()
  teardown: ->
    foundry.tearDown()

test 'attribute can autoincrement', ->
  foundry.define 'User',
    id: foundry.sequence()

  a = foundry.build 'User'
  b = foundry.build 'User'
  c = foundry.build 'User'

  strictEqual a.id, '1', 'user sequence one'
  strictEqual b.id, '2', 'user sequence two'
  strictEqual c.id, '3', 'user sequence three'

test 'sequences accept a callback', ->
  foundry.define 'User',
    id: foundry.sequence (i) -> "User #{i}"

  a = foundry.build 'User'
  b = foundry.build 'User'
  c = foundry.build 'User'

  strictEqual a.id, 'User 1', 'user sequence one'
  strictEqual b.id, 'User 2', 'user sequence two'
  strictEqual c.id, 'User 3', 'user sequence three'

test 'sequences defined in the parent work', ->
  foundry.define 'Parent',
    uuid: foundry.sequence()

  foundry.define 'Child', from: 'Parent',
    name: "Adam"

  a = foundry.build 'Child'
  b = foundry.build 'Child'
  c = foundry.build 'Child'

  strictEqual a.id, '1', 'child with parent sequence one'
  strictEqual b.id, '2', 'child with parent sequence two'
  strictEqual c.id, '3', 'child with parent sequence three'

test 'an id sequence is added by default', ->
  foundry.define 'User'
    name: 'Adam'

  a = foundry.build 'User'
  b = foundry.build 'User'
  c = foundry.build 'User'

  strictEqual a.id, '1', 'rookie sequence one'
  strictEqual b.id, '2', 'rookie sequence two'
  strictEqual c.id, '3', 'rookie sequence three'

module "foundry - Create",
  setup: ->
    foundry.adapter = new Foundry.NullAdapter()

    foundry.define 'TestTodo', 
      name: 'Todo'

  teardown: ->
    foundry.adapter = new Foundry.NullAdapter()
    foundry.tearDown()

test 'objects can be created with the null adapter', ->
  todo = foundry.create 'TestTodo'
  equal todo.name, "Todo"

test 'create raise an error when there is no adapter', ->
  foundry.adapter = undefined

  raises (-> foundry.create('todo')), /adapter/i

module 'foundry - traits',
  setup: ->
    foundry.trait 'timestamps',
      created: 'yesterday',
      updated: 'today'

  teardown: ->
    foundry.tearDown()

test 'raise an errors on unknown traits', ->
  foundry.define 'Todo',
    task: 'Todo'

  raises (-> foundry.define('Todo', traits: 'fooBar'))

test 'traits can be used a definition time', ->
  foundry.define 'Todo', traits: 'timestamps',
    task: 'Todo'

  todo = foundry.build 'Todo'

  equal todo.task, 'Todo', 'Record build correctly'
  equal todo.created, 'yesterday', 'Trait built correctly'

test 'traits can be defined in parent classes', ->
  foundry.define 'Task', traits: 'timestamps',
    due: 'tomorrow'

  foundry.define 'Todo', from: 'Task',
    task: 'Todo'

  todo = foundry.build 'Todo'

  equal todo.task, 'Todo', 'Record build correctly'
  equal todo.created, 'yesterday', 'Trait built correctly'
  equal todo.updated, 'today', 'Trait built correctly'

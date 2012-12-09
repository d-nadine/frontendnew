module 'factory',
  teardown: ->
    Factory.tearDown()

test 'raises exception for undefined factory', ->
  raises (-> Factory.build('Unkown')), "must throw error for unkown definition"

test 'raise an error when redifining a factory', ->
  Factory.define 'Contact'

  raises (-> Factory.define('Contact', {})), "Redifining must throw an error"

module 'factory - default values',
  setup: ->
    Factory.define 'Contact',
      id: '1'
      display_name: 'Ralph'
      status: 'prospect'

  teardown: ->
    Factory.tearDown()

test 'should create a default object with default values', ->
  contact = Factory.build 'Contact'

  equal contact.id, '1'
  equal contact.display_name, 'Ralph'
  equal contact.status, 'prospect'

test 'default values can be overriden in new instance', ->
  contact = Factory.build 'Contact',
    id: 2
    display_name: 'Bob'

  equal contact.id, '2'
  equal contact.display_name, 'Bob'
  equal contact.status, 'prospect'

test 'attributes can be function', ->
  contact = Factory.build 'Contact', 
    company: -> 'Nokia'

  equal contact.company, 'Nokia'

test 'attribute functions have access to the object', ->
  contact = Factory.build 'Contact',
    name: 'Adam'
    email: -> "#{@name}@radiumcrm.com"

  equal contact.email, "Adam@radiumcrm.com"

module 'Factory - Parent',
  setup: ->
    Factory.define 'Human',
      sex: 'Male'
  teardown: ->
    Factory.tearDown()

test 'a factory can define a parent and extend its defaults', ->
  Factory.define 'Anne', from: 'Human',
    first_name: 'Anne'
    surname: 'Sauer'
    sex: 'Female'

  paul = Factory.build 'Anne'

  equal paul.first_name, 'Anne', 'first name'
  equal paul.surname, 'Sauer', 'surname'
  equal paul.sex, 'Female', 'sex'

module 'Factory - sequence',
  teardown: ->
    Factory.tearDown()

test 'attribute can autoincrement', ->
  Factory.define 'User',
    id: Factory.sequence()

  a = Factory.build 'User'
  b = Factory.build 'User'
  c = Factory.build 'User'

  strictEqual a.id, '1', 'user sequence one'
  strictEqual b.id, '2', 'user sequence two'
  strictEqual c.id, '3', 'user sequence three'

test 'sequences accept a callback', ->
  Factory.define 'User',
    id: Factory.sequence (i) -> "User #{i}"

  a = Factory.build 'User'
  b = Factory.build 'User'
  c = Factory.build 'User'

  strictEqual a.id, 'User 1', 'user sequence one'
  strictEqual b.id, 'User 2', 'user sequence two'
  strictEqual c.id, 'User 3', 'user sequence three'

test 'sequences defined in the parent work', ->
  Factory.define 'Parent',
    uuid: Factory.sequence()

  Factory.define 'Child', from: 'Parent',
    name: "Adam"

  a = Factory.build 'Child'
  b = Factory.build 'Child'
  c = Factory.build 'Child'

  strictEqual a.id, '1', 'child with parent sequence one'
  strictEqual b.id, '2', 'child with parent sequence two'
  strictEqual c.id, '3', 'child with parent sequence three'

test 'an id sequence is added by default', ->
  Factory.define 'User'
    name: 'Adam'

  a = Factory.build 'User'
  b = Factory.build 'User'
  c = Factory.build 'User'

  strictEqual a.id, '1', 'rookie sequence one'
  strictEqual b.id, '2', 'rookie sequence two'
  strictEqual c.id, '3', 'rookie sequence three'

module "Factory - Create",
  setup: ->
    Factory.adapter = new Factory.NullAdapter()

    Factory.define 'TestTodo', 
      name: 'Todo'

  teardown: ->
    Factory.adapter = new Factory.NullAdapter()
    Factory.tearDown()

test 'objects can be created with the null adapter', ->
  todo = Factory.create 'TestTodo'
  equal todo.name, "Todo"

test 'create raise an error when there is no adapter', ->
  Factory.adapter = undefined

  raises (-> Factory.create('todo')), /adapter/i

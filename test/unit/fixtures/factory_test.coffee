test 'raises exception for undefined factory', ->
  raises (-> Factory.build('Unkown')), "must throw error for unkown definition"

module 'factory - default values',
  setup: ->
    Factory.define 'Contact',
      defaults:
        id: '1'
        display_name: 'Ralph'
        status: 'prospect'
  teardown: ->
    Factory.tearDown()

test 'should create a default object with default values', ->
  contact = Factory.contacts.default

  equal contact.id, '1'
  equal contact.display_name, 'Ralph'
  equal contact.status, 'prospect'
  equal contact.def.name, 'Contact', 'definition on hash'

test 'default values can be overriden in new instance', ->
  contact = Factory.build 'Contact',
    id: 2
    display_name: 'Bob'

  equal contact.id, '2'
  equal contact.display_name, 'Bob'
  equal contact.status, 'prospect'
  equal contact.def.name, 'Contact', 'definition on hash'
  notEqual contact, Factory.contacts.default

test 'should created named definition with default values', ->
  contact = Factory.build 'Contact', 'Ralph'

  contact = Factory.contacts.Ralph
  equal contact.id, '1'
  equal contact.display_name, 'Ralph'
  equal contact.status, 'prospect'
  equal contact.def.name, 'Contact', 'definition on hash'
  notEqual contact, Factory.contacts.default

test 'should create named definition with overriden values', ->
  Factory.build 'Contact', 'Paul',
    id: 3
    display_name: 'Paul'

  contact = Factory.contacts.Paul

  equal contact.id, '3'
  equal contact.display_name, 'Paul'
  equal contact.status, 'prospect'
  equal contact.def.name, 'Contact', 'definition on hash'
  notEqual contact, Factory.contacts.default

module 'Factory with no defaults',
  setup: ->
    Factory.define 'Test'
  teardown: ->
    Factory.tearDown()

test 'can define a definition with no defaults', ->
  ok Factory.tests.default, 'default object with no defaults'

module 'Factory - Parent',
  setup: ->
    Factory.define 'Human',
      defaults:
        sex: 'Male'
  teardown: ->
    Factory.tearDown()

test 'a factory can define a parent and extend its defaults', ->
  Factory.define 'Paul',
    parent: 'Human'
    defaults:
      first_name: 'Paul'
      surname: 'Cowan'

  paul = Factory.build 'Paul',
    first_name: 'Paul'
    surname: 'Cowan'

  equal paul.first_name, 'Paul', 'first name'
  equal paul.surname, 'Cowan', 'surname'
  equal paul.sex, 'Male', 'sex'
  equal paul.def.name, 'Paul', 'definition on hash'

module 'Factory#GetDefinitions'
  setup: ->
    Factory.define 'Test'
  teardown: ->
    Factory.tearDown()

test 'all definitions can be returned', ->
 defs = Factory.getDefinitions()
 equal 1, defs.length, '1 definitions in factory'

module 'Factory - abstract',
  setup: ->
    Factory.define 'Base',
      abstract: true
      defaults:
        key: 'Value'
   teardown: ->
    Factory.tearDown()

test 'no default instance is created for an abstract definition', ->
  equal null, Factory.bases.default, 'no base default'

module 'Factory - function attributes',
  setup: ->
    a = 3
    b = 4
    Factory.define 'Func',
      defaults:
        result: ->
          a * b
        timestamp: ->
          new Date()
  teardown: ->
    Factory.tearDown()

test 'a function attribute will be evaluated', ->
  func = Factory.funcs.default
  ok func, 'func has been created'
  equal 12, func.result, 'func result expression'
  ok func.timestamp.getMonth, 'func date created'

module 'Factory - Associations',
  setup: ->
    Factory.define 'User'

    Factory.build 'User', 'Paul',
      id: 1
      name: 'Paul Cowan'

    Factory.build 'User', 'Bob',
      id: 2
      name: 'Bob Robertson'

    Factory.define 'Todo',
      defaults:
        kind: 'general'
        finished: true

  teardown: ->
    Factory.tearDown()

test 'a named factory instance can be associated with another', ->
  Factory.build 'Todo', 'overdue',
    finished: false
    user: Factory.association('User', 'Paul')

  equal Factory.todos.overdue.user.name, 'Paul Cowan', 'User set on Todo' 

test 'a named instance can be referenced and have its values overriden', ->
  Factory.build 'User', 'Robert',
    id: 3
    name: 'Robert Smith'
    city: 'Glasgow'

  equal 'Glasgow', Factory.users.Robert.city, 'precond - initial city set'

  Factory.build 'Todo', 'deal',
    kind: 'deal'
    user: Factory.association('User', 'Robert', city: 'Belfast')

  deal = Factory.todos.deal

  equal 3, deal.user.id, 'user id maintained'
  equal 'Robert Smith', deal.user.name, 'user name maintained'
  equal 'Belfast', deal.user.city, 'user city overriden'

test 'an array of ids from named instances can be embedded in another', ->
  Factory.build 'Todo', 'Campaign',
    kind: 'campaign'
    users: Factory.association('User', ['Paul', 'Bob'])

  campaign = Factory.todos.Campaign
  equal 2, campaign.users.length, 'campaign todo has 2 users'
  equal 1, campaign.users[0], 'caompaign first user is an id'
  equal "1,2", campaign.users.join(','), 'campaign has user ids'

test 'an array of named instances can be embedded within another', ->
  Factory.build 'Todo', 'call',
    kind: 'call'
    users: Factory.association('User', ['Paul', 'Bob'], embedded: true)

  todo = Factory.todos.call
  equal 2, todo.users.length, 'call todo has 2 users'
  equal 'Paul Cowan', todo.users[0].name

module 'Factory - sequence',
  teardown: ->
    Factory.tearDown()

test 'attribute can autoincrement', ->
  Factory.define 'User',
    abstract: true
    defaults:
      id: Factory.sequence()

  a = Factory.build 'User'
  b = Factory.build 'User'
  c = Factory.build 'User'

  strictEqual a.id, '1', 'user sequence one'
  strictEqual b.id, '2', 'user sequence two'
  strictEqual c.id, '3', 'user sequence three'

test 'sequences accept a callback', ->
  Factory.define 'User',
    abstract: true
    defaults:
      id: Factory.sequence (i) -> "User #{i}"

  a = Factory.build 'User'
  b = Factory.build 'User'
  c = Factory.build 'User'

  strictEqual a.id, 'User 1', 'user sequence one'
  strictEqual b.id, 'User 2', 'user sequence two'
  strictEqual c.id, 'User 3', 'user sequence three'

test 'an id sequence is added by default', ->
  Factory.define 'User'
    abstract: true
    defaults:
      name: 'Adam'

  a = Factory.build 'User'
  b = Factory.build 'User'
  c = Factory.build 'User'

  strictEqual a.id, '1', 'rookie sequence one'
  strictEqual b.id, '2', 'rookie sequence two'
  strictEqual c.id, '3', 'rookie sequence three'

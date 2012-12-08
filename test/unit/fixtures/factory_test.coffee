module 'factory',
  teardown: ->
    Factory.tearDown()

test 'raises exception for undefined factory', ->
  raises (-> Factory.build('Unkown')), "must throw error for unkown definition"

test 'raise an error when redifining a factory', ->
  debugger
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
  debugger

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

# module 'Factory#GetDefinitions'
#   setup: ->
#     Factory.define 'Test'
#   teardown: ->
#     Factory.tearDown()

# test 'all definitions can be returned', ->
#  defs = Factory.getDefinitions()
#  equal 1, defs.length, '1 definitions in factory'

# module 'Factory - abstract',
#   setup: ->
#     Factory.define 'Base',
#       abstract: true
#       defaults:
#         key: 'Value'
#    teardown: ->
#     Factory.tearDown()

# test 'no default instance is created for an abstract definition', ->
#   equal null, Factory.bases.default, 'no base default'

# module 'Factory - Associations',
#   setup: ->
#     Factory.define 'User'

#     Factory.build 'User', 'Paul',
#       id: 1
#       name: 'Paul Cowan'

#     Factory.build 'User', 'Bob',
#       id: 2
#       name: 'Bob Robertson'

#     Factory.define 'Todo',
#       defaults:
#         kind: 'general'
#         finished: true

#   teardown: ->
#     Factory.tearDown()

# test 'a named factory instance can be associated with another', ->
#   Factory.build 'Todo', 'overdue',
#     finished: false
#     user: Factory.association('User', 'Paul')

#   equal Factory.todos.overdue.user.name, 'Paul Cowan', 'User set on Todo' 

# test 'a named instance can be referenced and have its values overriden', ->
#   Factory.build 'User', 'Robert',
#     id: 3
#     name: 'Robert Smith'
#     city: 'Glasgow'

#   equal 'Glasgow', Factory.users.Robert.city, 'precond - initial city set'

#   Factory.build 'Todo', 'deal',
#     kind: 'deal'
#     user: Factory.association('User', 'Robert', city: 'Belfast')

#   deal = Factory.todos.deal

#   equal 3, deal.user.id, 'user id maintained'
#   equal 'Robert Smith', deal.user.name, 'user name maintained'
#   equal 'Belfast', deal.user.city, 'user city overriden'

# test 'an array of ids from named instances can be embedded in another', ->
#   Factory.build 'Todo', 'Campaign',
#     kind: 'campaign'
#     users: Factory.association('User', ['Paul', 'Bob'])

#   campaign = Factory.todos.Campaign
#   equal 2, campaign.users.length, 'campaign todo has 2 users'
#   equal 1, campaign.users[0], 'caompaign first user is an id'
#   equal "1,2", campaign.users.join(','), 'campaign has user ids'

# test 'an array of named instances can be embedded within another', ->
#   Factory.build 'Todo', 'call',
#     kind: 'call'
#     users: Factory.association('User', ['Paul', 'Bob'], embedded: true)

#   todo = Factory.todos.call
#   equal 2, todo.users.length, 'call todo has 2 users'
#   equal 'Paul Cowan', todo.users[0].name

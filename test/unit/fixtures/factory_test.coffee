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

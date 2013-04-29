Number::randomize = ->
  Math.floor(Math.random() * this)

class Populator
  @run: ->
    settings = Factory.create 'settings'

    settings.get('negotiatingStatuses').forEach (status) ->
      Dictionaries.dealStatuses.add status

    names = [
      'Adam Hawkins'
      'Paul Cowan'
      'Joshua Jones'
      'Sami Asikainen'
      'Riikka Tarkainen'
    ]

    companies =for i in [0..20]
      Factory.create 'company'

    companiesDictionary = new Dictionary(companies)

    users = names.map (name) ->
      Factory.create 'user',
        name: name
        email: "#{name.split(' ')[0].toLowerCase()}@radiumcrm.com"

    userDictionary = new Dictionary(users)

    meetingHash =
      user: -> userDictionary.random()
      users: -> [userDictionary.set[0], userDictionary.set[1]]
      startsat: Ember.DateTime.create().advance(day: 7)
      endsat: Ember.DateTime.create().advance(day: 7).advance(hour: 3)

    todoList = -> [
          Factory.create('todo')
          Factory.create('todo', isFinished: true)
        ]

    callList = -> [
        Factory.create('call')
        Factory.create('call', isFinished: true)
      ]

    contacts = for i in [0..20]
      Factory.create 'contact',
        user: -> userDictionary.random()
        meetings: -> [Factory.create 'meeting', meetingHash]
        todos: -> [Factory.create('todo')]
        calls: -> [Factory.create('call')]
        company: -> companiesDictionary.random()

    contactDictionary = new Dictionary(contacts)

    deals = for i in [0..20]
      Factory.create 'deal',
        user: -> userDictionary.random()
        contact: -> contactDictionary.random()

    dealDictionary = new Dictionary(deals)

    for i in [0..20]
      Factory.create 'call',
        user: -> userDictionary.random()
        contact: -> contactDictionary.random()
        reference: -> contactDictionary.random()

    for i in [0..30]
      Factory.create 'email',
        sender: -> if Math.random() >= 0.5 then userDictionary.random() else contactDictionary.random()
        todos: todoList
        calls: callList
        to: ->
          if @sender instanceof Radium.User
            [contactDictionary.random()]
          else
            [userDictionary.random()]
        cc: -> [userDictionary.random(), contactDictionary.random()]
        bcc: -> [userDictionary.random(), contactDictionary.random()]

        meetings: -> [
          Factory.create 'meeting', meetingHash
        ]

    for i in [0..20]
      Factory.create 'group'

    Factory.create 'meeting', meetingHash

    for i in [0..10]
      Factory.create 'todo',
        user: userDictionary.random()
        todos: todoList
        calls: callList
        meetings: -> [
          Factory.create 'meeting', meetingHash
        ]

    for i in [0..10]
      Factory.create 'meeting',
        user: -> userDictionary.random()
        users: -> [userDictionary.set[0], userDictionary.set[1]]
        startsat: Ember.DateTime.create().advance(day: 7)
        endsat: Ember.DateTime.create().advance(day: 7).advance(hour: 3)
        todos: todoList
        calls: callList

    for i in [0..10]
      Factory.create 'discussion',
        user: userDictionary.random()
        users: [userDictionary.random(), userDictionary.random()]
        reference: ->
          if Math.random() >= 0.5
            contactDictionary.random()
          else
            dealDictionary.random()
        todos: todoList
        calls: callList
        meetings: -> [
          Factory.create 'meeting', meetingHash
        ]

    Factory.adapter.store.commit()

Radium.Populator = Populator


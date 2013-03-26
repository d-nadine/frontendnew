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

    users = names.map (name) ->
      Factory.create 'user',
        name: name
        email: "#{name.split(' ')[0].toLowerCase()}@radiumcrm.com"

    userDictionary = new Dictionary(users)

    contacts = for i in [0..20]
      Factory.create 'contact',
        user: -> userDictionary.random()

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
        todos: -> [
          Factory.create('todo')
          Factory.create('call')
          Factory.create('todo', isFinished: true)
          Factory.create('call', isFinished: true)
        ]
        meetings: -> [
          Factory.create('meeting')
        ]

    for i in [0..20]
      Factory.create 'group'

    Factory.create 'meeting',
      user: -> userDictionary.random()
      users: -> [userDictionary.random()]
      contacts: -> [contactDictionary.random()]
      startsAt: Ember.DateTime.create().advance(day: 7)
      endsAt: Ember.DateTime.create().advance(day: 7).advance(hour: 3)

    for i in [0..10]
      Factory.create 'discussion',
        user: userDictionary.random()
        users: [userDictionary.random(), userDictionary.random()]
        reference: ->
          if Math.random() >= 0.5
            contactDictionary.random()
          else
            dealDictionary.random()
        todos: -> [
          Factory.create('todo')
          Factory.create('call')
          Factory.create('todo', isFinished: true)
          Factory.create('call', isFinished: true)
        ]
        meetings: -> [
          Factory.create('meeting')
        ]

    Factory.adapter.store.commit()

Radium.Populator = Populator

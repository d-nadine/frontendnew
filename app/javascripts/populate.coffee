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
      Factory.create 'user'
        name: name
        email: "#{name.split(' ')[0].toLowerCase()}@radiumcrm.com"

    contacts = for i in [0..20]
      Factory.create 'contact'
        user: -> users[(users.length).randomize()]

    userDictionary = new Dictionary(users)
    contactDictionary = new Dictionary(contacts)

    startsAt = Ember.DateTime.create().advance(hour: 1)
    endsAt = Ember.DateTime.create().advance(hour: 3)

    retrospection = Factory.create 'meeting',
      topic: 'Retrospection'
      location: 'Radium HQ'
      startsAt: startsAt
      endsAt: endsAt
      users:  [
        aaron,
        jerry
      ]

    discussion1 = Factory.create 'discussion',
      topic: 'Discussion about the deal'
      users:  [
        aaron,
        jerry
      ]

    email = Factory.create 'email',
      subject: 'Subject of the email'
      sender: jerry

    email1 = Factory.create 'email',
      sender: aaron

    email2 = Factory.create 'email',
      sender: ralph

    email3 = Factory.create 'email',
      sender: john

    for i in [0..20]
      Factory.create 'deal',
        user: -> userDictionary.random()
        contact: -> contactDictionary.random()

    for i in [0..20]
      Factory.create 'call'
        user: -> userDictionary.random()
        contact: -> contactDictionary.random()

    for i in [0..30]
      Factory.create 'email'
        sender: -> if Math.random() >= 50 then userDictionary.random() else contactDictionary.random()

    Factory.adapter.store.commit()

Radium.Populator = Populator

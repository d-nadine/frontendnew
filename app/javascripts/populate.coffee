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

Radium.Populator = Populator

class Populator
  @run: ->
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

    users.forEach (user) ->
      nameKey = user.get('name').split(' ')[0].underscore()
      userDictionary[nameKey] = user

    # globalize it so other populators can access the 
    # predefined set of users
    Dictionary.users = userDictionary

    companies = for i in [1..5]
      Factory.create 'company'

    companiesDictionary = new Dictionary(companies)

    groups = for i in [1..5]
      Factory.create 'group'

    groupsDictionary = new Dictionary(groups)

    contacts = for i in [1..10]
      Factory.create 'contact',
        user: -> userDictionary.random()
        company: -> companiesDictionary.random()
        groups: -> [
          groupsDictionary.random()
          groupsDictionary.random()
        ]

    settings = Factory.create 'settings'

    settings.get('negotiatingStatuses').forEach (status) ->
      Dictionaries.dealStatuses.add status

    Factory.adapter.store.commit()

Radium.Populator = Populator


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

    companyDictionary = new Dictionary(companies)

    groups = for i in [1..5]
      Factory.create 'group'

    groupDictionary = new Dictionary(groups)

    contacts = for i in [1..10]
      Factory.create 'contact',
        user: -> userDictionary.random()
        company: -> companyDictionary.random()
        groups: -> [
          groupDictionary.random()
          groupDictionary.random()
        ]

    contactDictionary = new Dictionary(contacts)

    settings = Factory.create 'settings'

    settings.get('negotiatingStatuses').forEach (status) ->
      Dictionaries.dealStatuses.add status

    deal = Factory.create 'deal',
      contact: contactDictionary.random()
      user: userDictionary.random()

    dealDictionary = new Dictionary([deal])

    email1 = Factory.create 'email',
      sender: userDictionary.random()
      to: [contactDictionary.random()]

    email2 = Factory.create 'email',
      to: [userDictionary.random()]
      sender: contactDictionary.random()

    emailDictionary = new Dictionary([email1, email2])

    Factory.create 'activity',
      tag: 'follow'
      meta:
        follower: userDictionary.random()
        following: userDictionary.random()

    Factory.create 'activity',
      tag: 'follow'
      meta:
        follower: userDictionary.random()
        following: contactDictionary.random()

    Factory.create 'activity',
      tag: 'follow'
      meta:
        follower: userDictionary.random()
        following: companyDictionary.random()

    Factory.create 'activity',
      tag: 'follow'
      meta:
        follower: userDictionary.random()
        following: groupDictionary.random()

    Factory.create 'activity',
      tag: 'follow'
      meta:
        follower: userDictionary.random()
        following: dealDictionary.random()

    Factory.adapter.store.commit()

Radium.Populator = Populator


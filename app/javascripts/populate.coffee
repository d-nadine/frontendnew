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

    discussion = Factory.create 'discussion',
      user: userDictionary.random()
      users: [userDictionary.random(), userDictionary.random()]
      reference: contactDictionary.random()

    discussionDictionary = new Dictionary([discussion])

    meeting = Factory.create 'meeting',
      user: userDictionary.random()
      users: [userDictionary.random(), userDictionary.random()]
      contacts: [contactDictionary.random()]

    meetingDictionary = new Dictionary([meeting])

    todos = for i in [0..10]
      Factory.create 'todo',
        user: userDictionary.random()
        reference: contactDictionary.random()

    todoDictionary = new Dictionary(todos)

    # Factory.create 'activity',
    #   tag: 'follow'
    #   meta:
    #     follower: userDictionary.random()
    #     following: userDictionary.random()

    # Factory.create 'activity',
    #   tag: 'follow'
    #   meta:
    #     follower: userDictionary.random()
    #     following: contactDictionary.random()

    # Factory.create 'activity',
    #   tag: 'follow'
    #   meta:
    #     follower: userDictionary.random()
    #     following: companyDictionary.random()

    # Factory.create 'activity',
    #   tag: 'follow'
    #   meta:
    #     follower: userDictionary.random()
    #     following: groupDictionary.random()

    # Factory.create 'activity',
    #   tag: 'follow'
    #   meta:
    #     follower: userDictionary.random()
    #     following: dealDictionary.random()

    # Factory.create 'activity',
    #   tag: 'discussion'
    #   reference: discussionDictionary.random()
    #

    # [contactDictionary, discussionDictionary, dealDictionary].forEach (dict) ->
    #   Factory.create 'activity',
    #     tag: 'attachment'
    #     reference: Factory.create 'attachment',
    #       reference: dict.random()
    #       user: userDictionary.random()
    #     user: userDictionary.random()
    #     meta:
    #       event: 'create'

    #   Factory.create 'activity',
    #     tag: 'attachment'
    #     reference: Factory.create 'attachment',
    #       reference: dict.random()
    #       user: userDictionary.random()
    #     user: userDictionary.random()
    #     meta:
    #       event: 'update'

    #   Factory.create 'activity',
    #     tag: 'attachment'
    #     reference: Factory.create 'attachment',
    #       reference: dict.random()
    #       user: userDictionary.random()
    #     user: userDictionary.random()
    #     meta:
    #       event: 'delete'

    # Factory.create 'activity',
    #   tag: 'call'
    #   user: userDictionary.random()
    #   reference: Factory.create 'call',
    #     reference: contactDictionary.random()
    #     user: userDictionary.random()
    #     description: null
    #   meta:
    #     event: 'create'

    # Factory.create 'activity',
    #   tag: 'call'
    #   user: userDictionary.random()
    #   reference: Factory.create 'call',
    #     reference: contactDictionary.random()
    #     user: userDictionary.random()
    #     description: "Ask about the fall line up"
    #   meta:
    #     event: 'create'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     company: companyDictionary.random()
    #     event: 'primary_contact'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'create'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'delete'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'assign'
    #     user: userDictionary.random()

    # Factory.create 'activity',
    #   tag: 'company'
    #   user: userDictionary.random()
    #   reference: companyDictionary.random()
    #   meta:
    #     event: 'create'

    # Factory.create 'activity',
    #   tag: 'company'
    #   user: userDictionary.random()
    #   reference: companyDictionary.random()
    #   meta:
    #     event: 'update'

    # Factory.create 'activity',
    #   tag: 'company'
    #   user: userDictionary.random()
    #   reference: companyDictionary.random()
    #   meta:
    #     event: 'assign'
    #     user: userDictionary.random()
    #
    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'update'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     status: 'contact'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     status: 'lead'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     status: 'prospect'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     status: 'customer'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'assign'
    #     user: userDictionary.random()

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     status: 'contact'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'create'
    #     status: 'none'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'create'
    #     status: 'lead'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'create'
    #     status: 'customer'

    # Factory.create 'activity',
    #   tag: 'contact'
    #   user: userDictionary.random()
    #   reference: contactDictionary.random()
    #   meta:
    #     event: 'delete'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     status: 'closed'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     status: 'lost'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'status_change'
    #     negotiating: true
    #     status: 'waiting for signature'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'publish'

    # Factory.create 'activity',
    #   tag: 'deal'
    #   user: userDictionary.random()
    #   reference: dealDictionary.random()
    #   meta:
    #     event: 'publish'

    # Factory.create 'activity',
    #   tag: 'meeting'
    #   user: userDictionary.random()
    #   reference: meetingDictionary.random()
    #   meta:
    #     event: 'reschedule'
    #     time: Ember.DateTime.create()

    # Factory.create 'activity',
    #   tag: 'meeting'
    #   user: userDictionary.random()
    #   reference: meetingDictionary.random()
    #   meta:
    #     event: 'cancel'

    # Factory.create 'activity',
    #   tag: 'meeting'
    #   user: userDictionary.random()
    #   reference: meetingDictionary.random()
    #   meta:
    #     event: 'create'

    # Factory.create 'activity',
    #   tag: 'meeting'
    #   user: userDictionary.random()
    #   reference: meetingDictionary.random()
    #   meta:
    #     event: 'update'

    # Factory.create 'activity',
    #   tag: 'todo'
    #   user: userDictionary.random()
    #   reference: todoDictionary.random()
    #   meta:
    #     event: 'finish'

    # Factory.create 'activity',
    #   tag: 'todo'
    #   user: userDictionary.random()
    #   reference: todoDictionary.random()
    #   meta:
    #     event: 'assign'
    #     user: userDictionary.random()

    Factory.create 'activity', 
      tag: 'email'
      user: userDictionary.random()
      reference: emailDictionary.random()
      meta:
        event: 'send'

    Factory.adapter.store.commit()

Radium.Populator = Populator


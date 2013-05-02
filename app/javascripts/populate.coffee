class Populator
  @run: ->
    names = [
      ['Adam', 'Hawkins']
      ['Paul', 'Cowan']
      ['Joshua', 'Jones']
      ['Sami',  'Asikainen']
      ['Riikka', 'Tarkainen']
    ]

    users = names.map (name) ->
      Factory.create 'user',
        firstName: name[0]
        lastName: name[1]
        email: "#{name[0].toLowerCase()}@radiumcrm.com"

    userDictionary = new Dictionary(users)

    users.forEach (user) ->
      nameKey = user.get('firstName').underscore()
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

    Factory.create 'activity',
      tag: 'discussion'
      reference: discussionDictionary.random()

    [contactDictionary, discussionDictionary, dealDictionary].forEach (dict) ->
      Factory.create 'activity',
        tag: 'attachment'
        event: 'create'
        reference: Factory.create 'attachment',
          reference: dict.random()
          user: userDictionary.random()
        user: userDictionary.random()

      Factory.create 'activity',
        tag: 'attachment'
        event: 'update'
        reference: Factory.create 'attachment',
          reference: dict.random()
          user: userDictionary.random()
        user: userDictionary.random()

      Factory.create 'activity',
        tag: 'attachment'
        event: 'delete'
        reference: Factory.create 'attachment',
          reference: dict.random()
          user: userDictionary.random()
        user: userDictionary.random()

    Factory.create 'activity',
      tag: 'call'
      event: 'create'
      user: userDictionary.random()
      reference: Factory.create 'call',
        reference: contactDictionary.random()
        user: userDictionary.random()
        description: null

    Factory.create 'activity',
      tag: 'call'
      event: 'create'
      user: userDictionary.random()
      reference: Factory.create 'call',
        reference: contactDictionary.random()
        user: userDictionary.random()
        description: "Ask about the fall line up"

    Factory.create 'activity',
      tag: 'contact'
      event: 'primary_contact'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        company: companyDictionary.random()

    Factory.create 'activity',
      tag: 'deal'
      event: 'delete'
      user: userDictionary.random()
      reference: dealDictionary.random()

    Factory.create 'activity',
      tag: 'deal'
      event: 'assign'
      user: userDictionary.random()
      reference: dealDictionary.random()
      meta:
        user: userDictionary.random()

    Factory.create 'activity',
      tag: 'company'
      event: 'create'
      user: userDictionary.random()
      reference: companyDictionary.random()

    Factory.create 'activity',
      tag: 'company'
      event: 'update'
      user: userDictionary.random()
      reference: companyDictionary.random()

    Factory.create 'activity',
      tag: 'company'
      event: 'assign'
      user: userDictionary.random()
      reference: companyDictionary.random()
      meta:
        user: userDictionary.random()

    Factory.create 'activity',
      tag: 'contact'
      event: 'update'
      user: userDictionary.random()
      reference: contactDictionary.random()

    Factory.create 'activity',
      tag: 'contact'
      event: 'status_change'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'contact'

    Factory.create 'activity',
      tag: 'contact'
      event: 'status_change'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'lead'

    Factory.create 'activity',
      tag: 'contact'
      event: 'status_change'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'prospect'

    Factory.create 'activity',
      tag: 'contact'
      event: 'status_change'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'customer'

    Factory.create 'activity',
      tag: 'contact'
      event: 'assign'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        user: userDictionary.random()

    Factory.create 'activity',
      tag: 'contact'
      event: 'status_change'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'contact'

    Factory.create 'activity',
      tag: 'contact'
      event: 'create'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'none'

    Factory.create 'activity',
      tag: 'contact'
      event: 'create'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'lead'

    Factory.create 'activity',
      tag: 'contact'
      event: 'create'
      user: userDictionary.random()
      reference: contactDictionary.random()
      meta:
        status: 'customer'

    Factory.create 'activity',
      tag: 'contact'
      event: 'delete'
      user: userDictionary.random()
      reference: contactDictionary.random()

    Factory.create 'activity',
      tag: 'deal'
      event: 'status_change'
      user: userDictionary.random()
      reference: dealDictionary.random()
      meta:
        status: 'closed'

    Factory.create 'activity',
      tag: 'deal'
      event: 'status_change'
      user: userDictionary.random()
      reference: dealDictionary.random()
      meta:
        status: 'lost'

    Factory.create 'activity',
      tag: 'deal'
      event: 'status_change'
      user: userDictionary.random()
      reference: dealDictionary.random()
      meta:
        negotiating: true
        status: 'waiting for signature'

    Factory.create 'activity',
      tag: 'deal'
      event: 'close'
      user: userDictionary.random()
      reference: dealDictionary.random()

    Factory.create 'activity',
      tag: 'deal'
      event: 'lose'
      user: userDictionary.random()
      reference: dealDictionary.random()

    Factory.create 'activity',
      tag: 'deal'
      event: 'publish'
      user: userDictionary.random()
      reference: dealDictionary.random()

    Factory.create 'activity',
      tag: 'deal'
      event: 'publish'
      user: userDictionary.random()
      reference: dealDictionary.random()

    Factory.create 'activity',
      tag: 'meeting'
      event: 'reschedule'
      user: userDictionary.random()
      reference: meetingDictionary.random()
      meta:
        time: Ember.DateTime.create()

    Factory.create 'activity',
      tag: 'meeting'
      event: 'cancel'
      user: userDictionary.random()
      reference: meetingDictionary.random()

    Factory.create 'activity',
      tag: 'meeting'
      event: 'create'
      user: userDictionary.random()
      reference: meetingDictionary.random()

    Factory.create 'activity',
      tag: 'meeting'
      event: 'update'
      user: userDictionary.random()
      reference: meetingDictionary.random()

    Factory.create 'activity',
      tag: 'todo'
      event: 'finish'
      user: userDictionary.random()
      reference: todoDictionary.random()

    Factory.create 'activity',
      tag: 'todo'
      event: 'assign'
      user: userDictionary.random()
      reference: todoDictionary.random()
      meta:
        user: userDictionary.random()

    Factory.create 'activity', 
      tag: 'email'
      event: 'send'
      user: userDictionary.random()
      reference: emailDictionary.random()

    Factory.adapter.store.commit()

Radium.Populator = Populator


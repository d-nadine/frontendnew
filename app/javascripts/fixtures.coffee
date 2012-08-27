Fixture = Ember.Object.extend
  type: null
  name: null

# Basic implementation of fixtures, it registers helpers to load
# records based on fixtures easily, for example:
#
#     F.todos('with_todo') #=> <Radium.Todo ... >
window.Fixtures = Fixtures = Ember.Object.create
  init: ->
    @set('fixtures', Ember.Map.create())

  add: (type, fixtures) ->
    for name, data of fixtures
      fixture = Fixture.create
        type: type
        name: name
        data: data

      @addFixture(type, fixture)

  fetch: (type, name) ->
    @fixturesForType(type).get(name)

  addFixture: (type, fixture) ->
    fixtures = @fixturesForType(type)
    fixtures.set(fixture.get('name'), fixture)

  fixturesForType: (type) ->
    map = @get('fixtures')

    fixtures = map.get(type)
    unless fixtures
      fixtures = Ember.Map.create()
      map.set(type, fixtures)
      Fixtures[Radium.Core.pluralize(Radium.Core.typeToString(type))] = (name) ->
        fixture = Fixtures.fetch(type, name)
        data    = fixture.get('data')
        Radium.store.load(type, data.id, data)
        Radium.store.find(type, data.id)

    fixtures

  loadAll: (options) ->
    options ?= {}
    now      = options.now

    @get('fixtures').forEach (type, fixtures) ->
      type.FIXTURES ?= []
      fixtures.forEach (name, fixture) ->
        data = fixture.get('data')
        if now
          Radium.store.load(type, data.id, data)
        else
          type.FIXTURES.pushObject(data)

window.F = F = Fixtures

Fixtures.add Radium.FeedSection,
  default:
    # TODO: think about the best way to handle id and lack of persistance here
    id: '2012-08-14'
    date: '2012-08-14T00:00:00Z'
    # I don't have any good idea on how to populate items array without
    # overwriting HasMany associations to update it whenever association
    # changes. This will take some time, so for now I'll leave it like this,
    # directly giving feed section what it needs
    item_ids: [
      [Radium.Todo, 1]
      [Radium.Todo, 3]
      [Radium.Todo, 4]
      [Radium.Todo, 5]
      [Radium.Todo, 6]
      [Radium.Todo, 7]
      [Radium.Todo, 8]
      [Radium.Todo, 9]
      [Radium.Todo, 10]
      [Radium.Meeting, 1]
      [Radium.Deal, 1]
      [Radium.CallList, 1]
      [Radium.Campaign, 1]
    ]
  feed_section_2:
    # TODO: think about the best way to handle id and lack of persistance here
    id: '2012-08-17'
    date: '2012-08-17T00:00:00Z'
    item_ids: [[Radium.Todo, 2]]

Fixtures.add Radium.CallList,
  default:
    id: 1
    created_at: '2012-08-14T15:27:32Z'
    updated_at: '2012-08-14T15:27:32Z'
    user_id: 1
    description: 'Call list'

Fixtures.add Radium.Deal,
  default:
    id: 1
    created_at: '2012-08-14T15:27:32Z'
    updated_at: '2012-08-14T15:27:32Z'
    user_id: 1
    state: 'pending'
    close_by: '2012-08-17T18:27:32Z'
    name: 'Great deal'

Fixtures.add Radium.Meeting,
  default:
    id: 1
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 2
    user_ids: [1, 2]
    starts_at: '2012-08-17T18:27:32Z'
    ends_at: '2012-08-18T18:27:32Z'
    topic: 'Product discussion'
    location: 'Radium HQ'

Fixtures.add Radium.Todo,
  default:
    id: 1
    created_at: '2012-08-14T18:27:32Z'
    updated_at: '2012-08-14T18:27:32Z'
    user_id: 1
    kind: 'general'
    description: 'Finish first product draft'
    finish_by: '2012-08-14T22:00:00Z'
    finished: false
    calendar_time: '2012-08-14T22:00:00Z'
    overdue: false
    comment_ids: [1]
  overdue:
    id: 2
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 2
    kind: 'general'
    description: 'Prepare product presentation'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: true
  call:
    id: 3
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'call'
    reference:
      id: 1
      type: 'contact'
    description: 'discussing offer details'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false
  deal:
    id: 4
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'general'
    reference:
      id: 1
      type: 'deal'
    description: 'Close the deal'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false
  campaign:
    id: 5
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'general'
    reference:
      id: 1
      type: 'campaign'
    description: 'Prepare campaign plan'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false
  email:
    id: 6
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'general'
    reference:
      id: 1
      type: 'email'
    description: 'write a nice response'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false
  group:
    id: 7
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'general'
    reference:
      id: 1
      type: 'group'
    description: 'schedule group meeting'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false
  phone_call:
    id: 8
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'general'
    reference:
      id: 1
      type: 'phone_call'
    description: 'product discussion'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false
  sms:
    id: 9
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'general'
    reference:
      id: 1
      type: 'sms'
    description: 'product discussion'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false
  with_todo:
    id: 10
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    kind: 'general'
    reference:
      id: 1
      type: 'todo'
    description: 'inception'
    finish_by: '2012-08-17T22:00:00Z'
    finished: false
    calendar_time: '2012-08-17T22:00:00Z'
    overdue: false

Fixtures.add Radium.Contact,
  ralph:
    id: 1
    display_name: 'Ralph'
    status: 'prospect'

Fixtures.add Radium.Campaign,
  default:
    id: 1
    name: 'Fall product campaign'
    user_id: 1

Fixtures.add Radium.Comment,
  default:
    id: 1
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    text: 'I like product drafts'
    user_id: 1

Fixtures.add Radium.Email,
  default:
    id: 1
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    sender:
      id: 2
      type: 'user'

Fixtures.add Radium.Group,
  default:
    id: 1
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    name: 'Product 1 group'

Fixtures.add Radium.PhoneCall,
  default:
    id: 1
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    to:
      id: 2
      type: 'user'
    from:
      id: 1
      type: 'contact'

Fixtures.add Radium.Sms,
  default:
    id: 1
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    sender_id: 2

Fixtures.add Radium.User,
  aaron:
    id: 1
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    name: 'Aaron Stephens'
    email: 'aaron.stephens13@feed-demo.com'
    phone: '136127245078'
    public: true
    avatar:
      small_url: '/images/fallback/small_default.png'
      medium_url: '/images/fallback/medium_default.png'
      large_url: '/images/fallback/large_default.png'
      huge_url: '/images/fallback/huge_default.png'
    account: 1
  jerry:
    id: 2
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    name: 'Jerry Parker'
    email: 'jerry.parker@feed-demo.com'
    phone: '136127245071'
    public: true
    avatar:
      small_url: '/images/fallback/small_default.png'
      medium_url: '/images/fallback/medium_default.png'
      large_url: '/images/fallback/large_default.png'
      huge_url: '/images/fallback/huge_default.png'
    account: 2


Fixtures.loadAll()

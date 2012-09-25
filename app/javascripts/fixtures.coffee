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

  # TODO: extract this as some kind of hook
  afterAdd: (type, fixtureSet, fixture) ->
    if type == Radium.FeedSection
      # automatically add next_date and previous_date
      fixtures = []
      fixtureSet.forEach (name, f) -> fixtures.pushObject(f)

      fixtures = fixtures.sort (a, b) ->
        if a.get('data').id > b.get('data').id then 1 else -1

      fixtures.forEach (fixture, i) ->
        if previous = fixtures.objectAt(i - 1)
          previous.get('data').next_date = fixture.get('data').id
          fixture.get('data').previous_date = previous.get('data').id
        if next = fixtures.objectAt(i + 1)
          next.get('data').previous_date = fixture.get('data').id
          fixture.get('data').next_date = next.get('data').id

  addFixture: (type, fixture) ->
    fixtures = @fixturesForType(type)
    fixtures.set(fixture.get('name'), fixture)
    @afterAdd(type, fixtures, fixture)

  fixturesForType: (type) ->
    map = @get('fixtures')

    fixtures = map.get(type)
    unless fixtures
      fixtures = Ember.Map.create()
      map.set(type, fixtures)
      Fixtures[Radium.Core.typeToString(type).pluralize()] = (name) ->
        fixture = Fixtures.fetch(type, name)
        data    = fixture.get('data')
        Radium.store.load(type, data.id, data) unless type.isInStore(data.id)
        Radium.store.find(type, data.id)

    fixtures

  loadAll: (options) ->
    options ?= {}
    now      = options.now

    @get('fixtures').forEach (type, fixtures) ->
      type.FIXTURES ?= []
      fixtures.forEach (name, fixture) ->
        data = fixture.get('data')
        type.FIXTURES.pushObject(data)
        if now
          Radium.store.load(type, data.id, data)

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
    _associatedUserIds: [1]
    _associatedGroupIds: [1]
  feed_section_2012_08_17:
    # TODO: think about the best way to handle id and lack of persistance here
    id: '2012-08-17'
    date: '2012-08-17T00:00:00Z'
    item_ids: [
      [Radium.Todo, 1]
      [Radium.Todo, 2]
      [Radium.Todo, 3]
      [Radium.Todo, 4]
    ]
    # this will normally not be needed, I just need it to easily filter
    # items in FixtureAdapter
    _associatedContactIds: [1]
    _associatedUserIds: [1]
  feed_section_2012_07_15:
    id: '2012-07-15'
    date: '2012-07-15T00:00:00Z'
    item_ids: [[Radium.Meeting, 2]]
  feed_section_4:
    id: '2012-07-14'
    date: '2012-07-14T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_5:
    id: '2012-07-13'
    date: '2012-07-13T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_6:
    id: '2012-07-12'
    date: '2012-07-12T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_7:
    id: '2012-07-11'
    date: '2012-07-11T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_8:
    id: '2012-07-10'
    date: '2012-07-10T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_9:
    id: '2012-07-09'
    date: '2012-07-09T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_10:
    id: '2012-07-08'
    date: '2012-07-08T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_11:
    id: '2012-07-07'
    date: '2012-07-07T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_12:
    id: '2012-07-06'
    date: '2012-07-06T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  feed_section_13:
    id: '2012-07-05'
    date: '2012-07-05T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  section_2012_08_31:
    id: '2012-08-31'
    date: '2012-08-31T00:00:00Z'
    item_ids: [[Radium.Deal, 2]]
  today:
    id: Ember.DateTime.create().toFormattedString('%Y-%m-%d')
    date: "#{Ember.DateTime.create().toFormattedString('%Y-%m-%d')}T00:00:00Z"
    item_ids: [[Radium.Deal, 2]]
  tomorrow:
    id: Ember.DateTime.create().advance(day: 1).toFormattedString('%Y-%m-%d')
    date: "#{Ember.DateTime.create().advance(day: 1).toFormattedString('%Y-%m-%d')}T00:00:00Z"
    item_ids: [[Radium.Deal, 3]]
  week_from_now:
    id: Ember.DateTime.create().advance(day: 7).toFormattedString('%Y-%m-%d')
    date: "#{Ember.DateTime.create().advance(day: 7).toFormattedString('%Y-%m-%d')}T00:00:00Z"
    item_ids: [[Radium.Deal, 2]]
  two_weeks_from_now:
    id: Ember.DateTime.create().advance(day: 14).toFormattedString('%Y-%m-%d')
    date: "#{Ember.DateTime.create().advance(day: 14).toFormattedString('%Y-%m-%d')}T00:00:00Z"
    item_ids: [[Radium.Deal, 2]]
  month_from_now:
    id: Ember.DateTime.create().advance(month: 1).toFormattedString('%Y-%m-%d')
    date: "#{Ember.DateTime.create().advance(month: 1).toFormattedString('%Y-%m-%d')}T00:00:00Z"
    item_ids: [[Radium.Deal, 2], [Radium.Todo, 11]]
    _associatedContactIds: [1]


for i in [1..200]
  date = Ember.DateTime.create().advance(day: 100 + i)
  data = {}
  data["additional_feed_section_in_future_#{i}"] = {
    id: date.toFormattedString('%Y-%m-%d')
    date: "#{date.toFormattedString('%Y-%m-%d')}T00:00:00Z"
    item_ids: [[Radium.Deal, 2]]
  }
  Fixtures.add Radium.FeedSection, data


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
  big_contract:
    id: 2
    created_at: '2012-07-15T15:27:32Z'
    updated_at: '2012-07-15T15:27:32Z'
    user_id: 1
    state: 'pending'
    close_by: '2012-07-15T18:27:32Z'
    name: 'Big contract'
  small_contract:
    id: 3
    created_at: '2012-07-15T15:27:32Z'
    updated_at: '2012-07-15T15:27:32Z'
    user_id: 1
    state: 'pending'
    close_by: '2012-07-15T18:27:32Z'
    name: 'Small contract'

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
  retrospection:
    id: 2
    created_at: '2012-07-15T18:27:32Z'
    updated_at: '2012-07-15T18:27:32Z'
    user_id: 2
    user_ids: [1, 2]
    starts_at: '2012-07-15T18:27:32Z'
    ends_at: '2012-07-15T18:27:32Z'
    topic: 'Retrospection'
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
  call_ralph:
    id: 11
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
  finish_by_tomorrow:
    id: 12
    created_at: '2012-08-17T18:27:32Z'
    updated_at: '2012-08-17T18:27:32Z'
    user_id: 1
    description: 'Buy office equipment'
    finish_by: "#{Ember.DateTime.create().advance(day: 1).toFormattedString('%Y-%m-%d')}T00:00:00Z"
    finished: false
    overdue: false

Fixtures.add Radium.Contact,
  ralph:
    id: 1
    display_name: 'Ralph'
    status: 'prospect'
  john:
    id: 2
    display_name: 'John'
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
  developers:
    id: 2
    created_at: '2012-06-23T17:44:53Z'
    updated_at: '2012-07-03T11:32:57Z'
    name: 'Developers'

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

Fixtures.add Radium.Notification,
  todo:
    id: 1
    reference:
      id: 1
      type: 'todo'
    created_at: '2012-08-14T18:27:32Z'
    updated_at: '2012-08-14T18:27:32Z'
    tag: 'assigned.todo'
  meeting_invitation:
    id: 2
    reference:
      id: 1
      type: 'invitation'
    created_at: '2012-08-14T18:27:32Z'
    updated_at: '2012-08-14T18:27:32Z'
    tag: 'invited.meeting'

Fixtures.add Radium.Invitation,
  for_meeting_1:
    id: 1
    user_id: 1
    meeting_id: 1

Fixtures.add Radium.Reminder,
  todo:
    id: 1
    time: '2012-08-14T18:27:32Z'
    reference:
      id: 1
      type: 'todo'
    created_at: '2012-08-14T18:27:32Z'
    updated_at: '2012-08-14T18:27:32Z'
  meeting:
    id: 2
    time: '2012-08-14T18:27:32Z'
    reference:
      id: 1
      type: 'meeting'
    created_at: '2012-08-14T18:27:32Z'
    updated_at: '2012-08-14T18:27:32Z'

Fixtures.add Radium.Message,
  default:
    id: 1
    type: 'email'
    sentAt: '2012-08-14T18:27:32Z'
    message: 'Hey, what\'s up?'

Radium.Gap.FIXTURES = []


Fixtures.loadAll()

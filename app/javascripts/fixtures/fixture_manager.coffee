Fixture = Ember.Object.extend
  type: null
  name: null

window.FixtureManager = FixtureManager = Ember.Object.extend
  init: ->
    @set('fixtures', Em.Map.create())

    @_super()

    for type, fixtures of FixtureManager.fixtures
      @add(type, fixtures)

  store: ( ->
    if store = @get('_store')
      store
    else
      Radium.store
  ).property('_store')

  add: (type, fixtures) ->
    type = Ember.get(Ember.lookup, type) if typeof(type) == 'string'

    for name, data of fixtures
      fixture = Fixture.create
        type: type
        name: name
        data: data

      @addFixture(type, fixture)

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

  fetch: (type, name) ->
    @fixturesForType(type).get(name)

  fixturesForType: (type) ->
    store = @get('store')
    map = @get('fixtures')

    fixtures = map.get(type)
    unless fixtures
      fixtures = Ember.Map.create()
      map.set(type, fixtures)
      self = this
      this[Radium.Core.typeToString(type).pluralize()] = (name) ->
        fixture = fixtures.get(name)
        data    = fixture.get('data')
        store.load(type, data.id, data) unless store.isInStore(type, data.id)
        store.find(type, data.id)

    fixtures

  loadAll: (options = {}) ->
    now = options.now
    store = @get('store')

    @get('fixtures').forEach (type, fixtures) ->
      type.FIXTURES ?= []
      fixtures.forEach (name, fixture) ->
        data = fixture.get('data')
        type.FIXTURES.pushObject(data)
        if now
          store.load(type, data.id, data)

    this

FixtureManager.reopenClass
  add: (type, fixture) ->
    FixtureManager.fixtures ?= {}
    FixtureManager.fixtures[type] ?= {}
    $.extend FixtureManager.fixtures[type], fixture

  load: ->
    for definition in Factory.getDefinitions()
      for own key, value of definition
        type = Radium.Core.typeFromString(value.def.name)
        delete value.def
        fixture = {}
        fixture[key] = value
        FixtureManager.add type, fixture

FixtureManager.load()

# TODO: initially fixtures were a singleton object, but that doesn't play
#       nice with unit tests, so I changed it to a class FixtureManager,
#       this should be probably reviewed and refactored
window.F = F = window.Fixtures = Fixtures = FixtureManager.create()

Fixtures.loadAll()

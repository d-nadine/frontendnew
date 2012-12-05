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

  addFixture: (type, fixture) ->
    fixtures = @fixturesForType(type)
    fixtures.set(fixture.get('name'), fixture)
    #TODO: Add afterAdd hook either here or factory

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

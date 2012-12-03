Fixture = Ember.Object.extend
  type: null
  name: null

window.FixtureManager = FixtureManager = Ember.Object.create
  init: ->
    @set('fixtures', Em.Map.create())

  add: (type, name, data) ->
    fixture = Fixture.create
      type: type
      name: name
      data: data

    @addFixture type, fixture

  addFixture: (type, fixture) ->
    fixtures = @fixturesForType(type)
    fixtures.set(fixture.get('name'), fixture)
    #TODO: Add afterAdd hook either here or factory

  fetch: (type, name) ->
    @fixturesForType(type).get(name)

  fixturesForType: (type) ->
    map = @get('fixtures')

    fixtures = map.get('type')
    unless fixtures
      fixtures = Ember.Map.create()
      map.set(type, fixtures)
      FixtureManager[Radium.Core.typeToString(type).pluralize()] = (name) ->
        fixture = FixtureManager.fetch(type, name)
        data = fixture.get 'data'
        fixture = FixtureManager.fetch(type, name)
        Radium.store.load(type, data.id, data) unless type.isInStore(data.id)
        Radium.store.find(type, data.id)

    fixtures

  loadAll: (options = {}) ->
    now = options.now

    for definition in Factory.getDefinitions()
      for own key, value of definition
        type = Radium.Core.typeFromString(value.def.name)
        delete value.def
        @add type, key, value

    @get('fixtures').forEach (type, fixtures) ->
      type.FIXTURES ?= []
      fixtures.forEach (name, fixture) ->
        # console.log "fixture = #{fixture.get('name')} - #{fixture.get('type')}"
        data = fixture.get('data')
        type.FIXTURES.pushObject(data)
        if now
          Radium.store.load(type, data.id, data)


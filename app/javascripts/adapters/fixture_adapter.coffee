require 'radium/adapters/fixture_adapter/fixture_serializer'

Radium.FixtureAdapter = DS.FixtureAdapter.extend
  simulateRemoteResponse: false
  dirtyRecordsForHasManyChange: Ember.K

  serializer: Radium.FixtureSerializer
  plurals: {}
  pluralize: (name) ->
    @plurals[name] || name + "s"

  queryFixtures: (fixtures, query, type) ->
    fixtureType = type.toString().split(".")[1]
    queryMethod = "query#{fixtureType}Fixtures"
    if @get queryMethod
      @get(queryMethod).call @, fixtures, query
    else
      throw new Error("Implement #{queryMethod} to query #{type}!")

  # TODO: fix queryFixtures in ember-data to pass type
  findQuery: (store, type, query, array) ->
    fixtures = @fixturesForType(type)

    Ember.assert "Unable to find fixtures for model type "+type.toString(), !!fixtures

    fixtures = @queryFixtures(fixtures, query, type)

    if fixtures
      @simulateRemoteCall (-> array.load fixtures ), store, type

require 'radium/adapters/fixture_adapter/queries/feed_section'
require 'radium/adapters/fixture_adapter/queries/gap'

require 'radium/adapters/fixture_adapter/maps'
require 'radium/adapters/fixture_adapter/transforms'

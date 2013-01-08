require 'radium/adapters/fixture_adapter/fixture_serializer'

Radium.FixtureAdapter = DS.FixtureAdapter.extend
  simulateRemoteResponse: false
  dirtyRecordsForHasManyChange: Ember.K

  serializer: Radium.FixtureSerializer
  plurals: {}
  pluralize: (name) ->
    @plurals[name] || name + "s"

  # Override find to mimic the fact that the server will
  # return empty feed sections for find by ID operations.
  # There is no such thing as ID for the feed, only date
  # ranges. So if we query for a specifid date we will either
  # get back an empty feed section or a populated one.
  # It will never be missing/nonexistent
  find: (store, type, id) ->
    if type isnt Radium.FeedSection
      @_super.apply this, arguments
    else
      fixtures = @fixturesForType type

      if existingSection = fixtures.findProperty('id', id)
        feedSection = existingSection
      else 
        feedSection = 
          id: id
          date: Ember.DateTime.parse("#{id}T00:00:00Z").toFullFormat()
          item_ids: []

      @simulateRemoteCall((->
        store.load type, feedSection
      ), store, type)

  queryFixtures: (fixtures, query, type) ->
    fixtureType = type.toString().split(".")[1]
    queryMethod = "query#{fixtureType}Fixtures"
    if @get queryMethod
      @get(queryMethod).call @, fixtures, query
    else
      throw new Error("Implement #{queryMethod} to query #{type}!")

  # TODO: this can go when upgrading to revision 10
  # https://github.com/emberjs/data/commit/23d40fb72fd600c39f10e9899e545ce8d78dd076
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

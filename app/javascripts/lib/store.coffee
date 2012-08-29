DS.RadiumStore = DS.Store.extend
  revision: 4
  adapter: DS.FixtureAdapter.create
    plurals: {}
    pluralize: (name) ->
      @plurals[name] || name + "s"

    queryFixtures: (fixtures, query, type) ->
      console.log('queryFixtures')
      if type == Radium.FeedSection
        if query.date
          chosenDate = Date.parse(query.date)
          deltas = []
          fixtures.forEach (f) ->
            delta = Math.abs chosenDate - Date.parse(f.date)
            deltas.pushObject [delta, f]

          deltas = deltas.sort (a, b) ->
            a = a[0]
            b = b[0]
            if a == b then 0 else ( if a > b then 1 else -1 )

          console.log(deltas)
          deltas.slice(0, 2).map (delta) -> delta[1]
        else
          fixtures.filter (f) -> f.id == '2012-08-14' || f.id == '2012-08-17'
      else
        fixtures

    # TODO: fix queryFixtures in ember-data to pass type
    findQuery: (store, type, query, array) ->
      fixtures = @fixturesForType(type)

      Ember.assert "Unable to find fixtures for model type "+type.toString(), !!fixtures

      fixtures = @queryFixtures(fixtures, query, type)

      if fixtures
        @simulateRemoteCall (-> array.load fixtures ), store, type

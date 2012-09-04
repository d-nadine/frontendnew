DS.RadiumStore = DS.Store.extend
  revision: 4

  expandableArrayFor: (type) ->
    recordArray = Radium.ExpandableRecordArray.create
      type: type
      content: Ember.A([])
      store: this

  adapter: DS.FixtureAdapter.create
    plurals: {}
    pluralize: (name) ->
      @plurals[name] || name + "s"

    queryFixtures: (fixtures, query, type) ->
      if type == Radium.FeedSection
        if query.date
          # Chrome deals with parsing dates in format yyyy-mm-dd,
          # but phantom (and maybe some of the browsers) does not
          chosenDate = Date.parse("#{query.date}T00:00:00Z")
          deltas = []
          fixtures.forEach (f) ->
            delta = Math.abs chosenDate - Date.parse(f.date)
            deltas.pushObject [delta, f]

          deltas = deltas.sort (a, b) ->
            a = a[0]
            b = b[0]
            if a == b then 0 else ( if a > b then 1 else -1 )

          deltas.slice(0, 2).map (delta) -> delta[1]
        else if item = (query.before || query.after)
          date = Date.parse("#{item}T00:00:00Z")
          fixtures = fixtures.filter (f) ->
            fixtureDate = Date.parse(f.date)
            if query.before
              fixtureDate < date
            else
              fixtureDate > date

          sort = if query.before then -1 else 1
          fixtures = fixtures.sort (a, b) ->
            a = Date.parse(a.date)
            b = Date.parse(b.date)
            if a == b then 0 else ( if a > b then sort else sort * -1 )

          fixtures.slice(0, query.limit || 1)
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

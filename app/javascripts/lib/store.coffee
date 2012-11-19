require 'radium/lib/adapter'
require 'radium/lib/serializer'

Radium.Store = DS.Store.extend
  revision: 8

  expandableArrayFor: (type) ->
    recordArray = Radium.ExpandableRecordArray.create
      type: type
      content: Ember.A([])
      store: this

  adapter: Radium.Adapter.create
    serializer: Radium.Serializer
    plurals: {}
    pluralize: (name) ->
      @plurals[name] || name + "s"

    queryFixtures: (fixtures, query, type) ->
      console.log 'queryFixtures'
      if type == Radium.Gap
        first = Date.parse "#{query.first}T00:00:00Z"
        last  = Date.parse "#{query.last}T00:00:00Z"

        sections = []
        Radium.FeedSection.FIXTURES.forEach (fixture) ->
          date = Date.parse fixture.date
          sections.pushObject fixture.id if date > first && date < last

        [{ id: "#{query.first}-#{query.last}", section_ids: sections }]

      else if type.root() == Radium.FeedSection
        type = query.type

        if type
          capitalized = type.capitalize()
          fixtures = fixtures.filter (f) ->
            if ids = f["_associated#{capitalized}Ids"]
              ids.find (id) -> id == query.id

        fixtures = if query.dates
          fixtures.filter (f) ->
            query.dates.contains f.id
        else if query.date
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

          deltas.slice(0, 4).map (delta) -> delta[1]
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

          if query.range && query.range != 'daily'
            if first = fixtures[0]
              date = Em.DateTime.parse first.id, '%Y-%m-%d'
              [date, endDate] = Radium.Utils.rangeForDate(date, query.range)
              date    = date.toFormattedString('%Y-%m-%d')
              endDate = endDate.toFormattedString('%Y-%m-%d')

              fixtures = fixtures.filter (f) ->
                f.id <= endDate && f.id >= date

            fixtures
          else
            fixtures.slice(0, query.limit || 1)
        else
          fixtures.filter (f) -> f.id == '2012-08-14' || f.id == '2012-08-17'

        fixtures
      else
        fixtures

    # TODO: fix queryFixtures in ember-data to pass type
    findQuery: (store, type, query, array) ->
      fixtures = @fixturesForType(type)

      Ember.assert "Unable to find fixtures for model type "+type.toString(), !!fixtures

      fixtures = @queryFixtures(fixtures, query, type)

      if fixtures
        @simulateRemoteCall (-> array.load fixtures ), store, type

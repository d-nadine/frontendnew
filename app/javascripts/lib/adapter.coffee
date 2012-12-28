require 'radium/lib/serializer'

# TODO: this changes should be done only
#       for API adapter, in FixtureAdapter
#       we could just use resulting keys
Radium.FixtureAdapter = DS.FixtureAdapter.extend
  simulateRemoteResponse: false
  dirtyRecordsForHasManyChange: Ember.K

  serializer: Radium.Serializer
  plurals: {}
  pluralize: (name) ->
    @plurals[name] || name + "s"

  queryFixtures: (fixtures, query, type) ->
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
            date    = date.toDateFormat()
            endDate = endDate.toDateFormat()

            fixtures = fixtures.filter (f) ->
              f.id <= endDate && f.id >= date

          fixtures
        else
          fixtures.slice(0, query.limit || 1)
      else
        startDates = [
          Ember.DateTime.create().toDateFormat()
          Ember.DateTime.create().advance(day: - 1).toDateFormat()
          Ember.DateTime.create().advance(day: - 7).toDateFormat()
          # Ember.DateTime.create().advance(day: - 14).toDateFormat()
        ]

        fixtures.filter (f) -> startDates.contains(f.id)

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

Radium.FixtureAdapter.map 'Radium.Meeting',
  users: { key: 'user_ids' }

Radium.FixtureAdapter.map 'Radium.Notification',
  referenceData: { key: 'reference' }

Radium.FixtureAdapter.map 'Radium.Todo',
  referenceData: { key: 'reference' }

Radium.FixtureAdapter.map 'Radium.Person',
  phoneCalls: { key: 'phone_calls' }

Radium.FixtureAdapter.map 'Radium.FeedSection',
  items: { key: 'item_ids' }

Radium.FixtureAdapter.map 'Radium.FeedSection',
  user: { key: 'user_id' }

Radium.FixtureAdapter.registerTransform 'array',
  fromData: (serialized) ->
    if Ember.isArray(serialized) then serialized else null
  toData: (deserialized) ->
    if Ember.isArray(deserialized) then deserialized else null

Radium.FixtureAdapter.registerTransform 'object',
  fromData: (serialized) ->
    if Ember.none(serialized) then {} else serialized
  toData: (deserialized) ->
    if Ember.none(deserialized) then {} else deserialized

Radium.FixtureAdapter.registerTransform 'datetime'
  fromData: (serialized) ->
    type = typeof serialized

    if type == "string" or type == "number"
      timezone = new Date().getTimezoneOffset()
      serializedDate = Ember.DateTime.parse serialized, @format
      serializedDate.toTimezone timezone
    else if Em.none serialized
      serialized
    else
      null

  toData: (deserialized) ->
    if deserialized instanceof Ember.DateTime
      normalized = deserialized.advance timezone: 0
      normalized.toFormattedString @format
    else if  deserialized == undefined
      undefined
    else
      null

  format: Ember.DATETIME_ISO8601


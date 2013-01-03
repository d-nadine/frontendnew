Radium.FixtureAdapter.reopen
  queryGapFixtures: (fixtures, query) ->
    first = Date.parse "#{query.first}T00:00:00Z"
    last  = Date.parse "#{query.last}T00:00:00Z"

    sections = []
    Radium.FeedSection.FIXTURES.forEach (fixture) ->
      date = Date.parse fixture.date
      sections.pushObject fixture.id if date > first && date < last

    [{ id: "#{query.first}-#{query.last}", section_ids: sections }]

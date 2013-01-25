Radium.FixtureAdapter.reopen
  queryDealFixtures: (fixtures, query) ->
    if query.statusFor
      return fixtures.filter (deal) -> deal.status == query.statusFor

    fixtures

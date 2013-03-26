Radium.FixtureAdapter.reopen
  queryDealFixtures: (records, query) ->
    if query.statusFor
      return records.filter (deal) -> deal.status == query.statusFor

    records

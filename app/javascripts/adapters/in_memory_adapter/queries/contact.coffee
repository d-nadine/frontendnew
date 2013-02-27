Radium.InMemoryAdapter.reopen
  queryContactFixtures: (fixtures, query) ->

    if query.statusFor
      return fixtures.filter (contact) -> contact.status == query.statusFor

    fixtures

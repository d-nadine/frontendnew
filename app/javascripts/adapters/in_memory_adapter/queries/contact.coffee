Radium.InMemoryAdapter.reopen
  queryContactRecords: (fixtures, query) ->

    if query.statusFor
      return fixtures.filter (contact) -> contact.status == query.statusFor

    fixtures

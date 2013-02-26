Radium.InMemoryAdapter.reopen
  queryAutoCompleteResultRecords: (fixtures, query) ->

    result =
      users: Radium.User.FIXTURES.filter((user) -> user.email).map (user) -> user.id
      contacts: Radium.Contact.FIXTURES.filter((contact) -> contact.email).map (contact) -> contact.id

    [result]


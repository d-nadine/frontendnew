Radium.InMemoryAdapter.reopen
  queryDealRecords: (records, query) ->
    if query.statusFor
      return records.filter (deal) -> deal.status == query.statusFor

    records

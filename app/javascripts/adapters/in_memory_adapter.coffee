Radium.InMemoryAdapter = DS.FixtureAdapter.extend
  serializer: DS.PassThroughSerializer
  simulateRemoteResponse: false

  queryRecords: (records, query, type) ->
    fixtureType = type.toString().split(".")[1]
    queryMethod = "query#{fixtureType}Records"
    if @get queryMethod
      @get(queryMethod).call @, fixtures, query
    else
      throw new Error("Implement #{queryMethod} to query #{type}!")

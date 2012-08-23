MockStore = Em.Object.extend
  argsList: []
  findByClientId: (type, clientId) ->
    @get('argsList').push(arguments)
    "#{type}:#{clientId}"

test 'extended array should get actual records from the store based on type and clientId', ->
  store = MockStore.create()
  array = Radium.ExtendedRecordArray.create(store: store)
  array.set('content', [["Todo", 1], ["Message", 5]])

  equal(array.objectAtContent(0), "Todo:1")
  equal(array.objectAtContent(1), "Message:5")

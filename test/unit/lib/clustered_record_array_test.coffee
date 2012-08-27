test 'clustered record array behaves as regular array when dealing with it', ->
  array = Radium.ClusteredRecordArray.create(store: Radium.store, clusterSize: 2)

  array.pushObject(Radium.store.find(Radium.Todo, 1))
  array.pushObject(Radium.store.find(Radium.User, 1))

  equal array.get('unclustered.length'), 2, 'unclustered items should allow to set more than one type'

  array.pushObject(Radium.store.find(Radium.Todo, 2))
  array.pushObject(Radium.store.find(Radium.Todo, 3))
  array.pushObject(Radium.store.find(Radium.Todo, 4))

  equal array.get('length'), 5, 'array should have correct length'
  equal array.objectAt(3).get('id'), 3, 'array should allow to retrieve records'

test 'clustered array adds records to clusters after reaching clusterSize', ->
  array = Radium.ClusteredRecordArray.create(store: Radium.store, clusterSize: 2)

  array.pushObject(Radium.store.find(Radium.Todo, 1))

  equal array.get('unclustered.length'), 1, 'first record should be added to unclustered'

  array.pushObject(Radium.store.find(Radium.Todo, 2))

  cluster = array.fetchCluster(Radium.Todo)
  ok cluster, 'cluster should be created for given type'
  equal cluster.get('length'), 2, 'cluster should contain all of the items'
  equal array.get('unclustered.length'), 0, 'clustered items should be removed from unclustered'

  array.pushObject(Radium.store.find(Radium.Todo, 3))

  equal cluster.get('length'), 3, 'cluster should contain all of the items'

test 'clustered array properly clears cluster after removing sufficient number of records', ->
  array = Radium.ClusteredRecordArray.create(store: Radium.store, clusterSize: 2)

  array.pushObject(Radium.store.find(Radium.Todo, 1))
  array.pushObject(Radium.store.find(Radium.Todo, 2))
  array.pushObject(Radium.store.find(Radium.Todo, 3))

  cluster = array.fetchCluster(Radium.Todo)
  equal cluster.get('length'), 3, 'cluster should contain all of the items'

  array.removeObject(Radium.store.find(Radium.Todo, 1))
  array.removeObject(Radium.store.find(Radium.Todo, 2))


  equal cluster.get('length'), 0, 'cluster should contain all of the items'
  equal array.get('unclustered.length'), 1, 'remaining items are moved to unclustered'

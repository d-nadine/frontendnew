# Array keeping clusters of items. Items are kept in 'unclustered'
# array (which can hold multiple record types). When items length for
# given type is equal to clusterSize, items are moved to cluster.
# Each additional item of type that's clustered, will be added to
# a cluster.
Radium.ClusteredRecordArray = Radium.ExtendedRecordArray.extend
  clusterSize: 5
  store: null

  init: ->
    @_super.apply this, arguments
    @set 'content', Ember.A() unless @get 'content'

    @set 'clusters', Em.ArrayProxy.create
      arrangedContent: (->
        @get('content').filter (cluster) -> cluster.get('length')
      ).property('content', 'content.@each.length')
      content: Ember.A()

    @set 'unclustered', Radium.ExtendedRecordArray.create
      store: @get('store')
      content: Ember.A()

  addRecord: (type, clientId) ->
    unclustered = @get('unclustered')
    filtered = unclustered.withType(type)

    if filtered.get('length') >= @get('clusterSize') - 1
      @addToCluster(type, clientId)
      while record = filtered.shiftObject()
        unclustered.removeObject(record)
        @addToCluster(type, record.get('clientId'))
    else
      cluster = @fetchCluster type
      if cluster.get('length')
        @addToCluster(type, clientId)
      else
        unclustered.pushObject([type, clientId])

  removeRecord: (record) ->
    unclustered = @get('unclustered')

    if unclustered.contains record
      unclustered.removeObject record
    else
      if @removeFromCluster(record)
        type = record.constructor
        cluster = @fetchCluster type
        if cluster.get('length') < @get('clusterSize')
          while record = cluster.shiftObject()
            @removeFromCluster(record)
            unclustered.pushObject(record)

  removeFromCluster: (record) ->
    type = record.constructor
    cluster = @fetchCluster type
    if cluster.contains record
      cluster.removeObject record
      true

  withType: (type) ->
    @filter (record) -> record.constructor == type

  addToCluster: (type, clientId) ->
    cluster = @fetchCluster type
    cluster.pushObject clientId

  prepareForReplace: (idx, amt, objects) ->
    self = this
    [idx, amt, objects] = @_super.apply(this, arguments)

    for object in objects
      @addRecord.apply(this, object)

    if amt
      for i in [0..(amt-1)]
        record = @objectAt(i + idx)
        @removeRecord record

    [idx, amt, objects]

  fetchCluster: (type) ->
    cluster = @get('clusters.content').find (c) -> c.get('type') == type

    unless cluster
      cluster = DS.RecordArray.create
        type: type
        strType: Radium.Core.typeToString type
        content: Ember.A([])
        store: @get('store')

      @get('clusters.content').pushObject(cluster)

    cluster

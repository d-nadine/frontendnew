# FIXME this should not be a dependency
require 'radium/show_more_mixin'

# Array keeping clusters of items. Items are kept in 'unclustered'
# array (which can hold multiple record types). When items length for
# given type is equal to clusterSize, items are moved to cluster.
# Each additional item of type that's clustered, will be added to
# a cluster.
Radium.ClusteredRecordArray = Ember.Mixin.create
  clusterSize: 5

  init: ->
    @_super.apply this, arguments
    @set 'content', Ember.A() unless @get 'content'

    @set 'clusters', Em.ArrayProxy.create
      store: @get('store')
      arrangedContent: (->
        @get('content').filter (cluster) -> cluster.get('length')
      ).property('content')

      contentArrayDidChange: (array, idx, removedCount, addedCount) ->
        self = this

        observer = ->
          if @get('length') == 0
            self.get('arrangedContent').removeObject(this)
          else if !self.get('arrangedContent').contains(this)
            self.get('arrangedContent').pushObject(this)

        addedObjects = array.slice(idx, idx + addedCount)
        for object in addedObjects
          object.addObserver 'length', observer

      content: Ember.A()

    @set 'unclustered', Radium.ExtendedRecordArray.create
      store: @get('store')
      content: Ember.A()

    self = this
    if @get('content.length') > 0
      @get('content').forEach (pairOrObject) ->
        pair = if Ember.isArray pairOrObject
          pairOrObject
        else
          [pairOrObject.constructor, pairOrObject.get('clientId')]

        self.addRecord.apply self, pair

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
        exists = unclustered.find (record) ->
          record.constructor == type && record.get('clientId') == clientId
        unclustered.pushObject([type, clientId]) unless exists

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

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    addedObjects = array.slice(idx, idx + addedCount)

    for object in addedObjects
      type     = null
      clientId = null

      if Ember.isArray(object)
        type     = object[0]
        clientId = object[1]
      else
        type     = object.constructor
        clientId = object.get('clientId')

      @addRecord(type, clientId)

    removedObjects = array.slice(idx, idx + removedCount)
    for object in removedObjects
      record = null

      if Ember.isArray(object)
        type     = object[0]
        clientId = object[1]
        record   = type.findByClientId type, clientId
      else
        record = object

      @removeRecord(record)

    @_super.apply(this, arguments)

  fetchCluster: (type) ->
    cluster = @get('clusters.content').find (c) -> c.get('type') == type

    unless cluster
      cluster = DS.RecordArray.create(Radium.ShowMoreMixin, {
        type: type
        content: Ember.A([])
        store: @get('store')
      })

      @get('clusters.content').pushObject(cluster)

    cluster

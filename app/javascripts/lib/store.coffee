DS.RadiumStore = DS.Store.extend
  revision: 4
  adapter: DS.RadiumAdapter.create(bulkCommit: false)
  bootstrap: ->
    adapter = @get('adapter')
    if adapter.bootstrap
      adapter.bootstrap()

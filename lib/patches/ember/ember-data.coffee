DS.Model.reopenClass
  humanize: ->
    @toString().humanize()

  instanceFromHash: (hash, key, type, store) ->
    id = hash[key]["id"]
    adapter = store.adapterForType(type)
    adapter.didFindRecord(store, type, hash, id)
    type.find(id)

DS.Model.reopen
  humanize: ->
    @constructor.humanize()

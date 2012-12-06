store = null
fixtures = null

module 'FixtureManager', setup: ->
    store = Radium.Store.create()
    store.get('_adapter').set('simulateRemoteResponse', false)
    fixtures = FixtureSet.create(store: store).loadAll()

  teardown: ->
    store.destroy()

test 'should create todo factory', ->
  id = '1'
  obj = null

  obj =  store.find(Radium.Meeting, id)

  console.log "feed = #{obj.get('topic')}"

  ok obj.get('isLoaded'), 'object is loaded'

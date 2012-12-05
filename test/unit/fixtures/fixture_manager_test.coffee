module 'FixtureManager', setup: ->
    Radium.store = Radium.Store.create()

  teardown: ->
    if Radium.store
      Radium.store.destroy()

test 'should create todo factory', ->
  FixtureManager.load()

  f = FixtureManager.create()
  f.loadAll(now: true)

  id = '1'

  obj =  Radium.Sms.find(id)
  console.log "feed = #{obj.get('id')}"

  ok obj.get('isLoaded'), 'object is loaded'

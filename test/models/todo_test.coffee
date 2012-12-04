store = null
fixtures = null

module 'Radium.Todo'
  setup: ->
    store = Radium.Store.create()
    store.get('_adapter').set('simulateRemoteResponse', false)
    fixtures = FixtureSet.create(store: store).loadAll()
  teardown: ->
    store.destroy()

test 'reference property can be set to a feed item', ->
  todo = fixtures.todos('default')
  meeting = fixtures.meetings('default')

  Ember.run ->
    todo.set 'reference', meeting

  equal todo.get('reference'), meeting, ''

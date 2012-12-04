store = null
fixtures = null

module 'Radium.PhoneCall'
  setup: ->
    store = Radium.Store.create()
    store.get('_adapter').set('simulateRemoteResponse', false)
    fixtures = FixtureSet.create(store: store).loadAll()
  teardown: ->
    store.destroy()

test 'associatedContacts return all contact records that are associated with given record', ->
  phone_call = fixtures.phone_calls('default')
  ralph      = fixtures.contacts('ralph')
  john       = fixtures.contacts('john')

  Ember.run ->
    phone_call.set 'to',   ralph
    phone_call.set 'from', john

  equal phone_call.get('associatedContacts.length'), 2, ''
  ok phone_call.get('associatedContacts').contains(ralph), ''
  ok phone_call.get('associatedContacts').contains(john), ''

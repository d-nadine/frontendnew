app '/'
Fixtures.loadAll(now: true)

module 'Radium.PhoneCall'

test 'associatedContacts return all contact records that are associated with given record', ->
  phone_call = F.phone_calls('default')
  ralph      = F.contacts('ralph')
  john       = F.contacts('john')

  Ember.run ->
    phone_call.set 'to',   ralph
    phone_call.set 'from', john

  equal phone_call.get('associatedContacts.length'), 2, ''
  ok phone_call.get('associatedContacts').contains(ralph), ''
  ok phone_call.get('associatedContacts').contains(john), ''

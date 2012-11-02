Radium.PhoneCall = Radium.Core.extend
  outcome: DS.attr('string')
  duration: DS.attr('number')
  kind: DS.attr('string')
  dialedAt: DS.attr('datetime')
  endedAt: DS.attr('datetime')
  to: Radium.polymorphic('to')
  from: Radium.polymorphic('from')

  associatedContacts: Radium.defineFeedAssociation(Radium.Contact, 'to', 'from')

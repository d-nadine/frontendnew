Radium.PhoneCall = Radium.Core.extend
  outcome: DS.attr('string')
  duration: DS.attr('number')
  kind: DS.attr('string')
  dialedAt: DS.attr('datetime')
  endedAt: DS.attr('datetime')

  to: Radium.polymorphicAttribute()
  from: Radium.polymorphicAttribute()

  associatedContacts: Radium.defineFeedAssociation(Radium.Contact, 'to', 'from')

  toUser: DS.belongsTo('Radium.User', polymorphicFor: 'to')
  toContact: DS.belongsTo('Radium.Contact', polymorphicFor: 'to')

  fromUser: DS.belongsTo('Radium.User', polymorphicFor: 'from')
  fromContact: DS.belongsTo('Radium.Contact', polymorphicFor: 'from')

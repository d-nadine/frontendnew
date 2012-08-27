Radium.PhoneCall = Radium.Core.extend
  outcome: DS.attr('string')
  duration: DS.attr('number')
  kind: DS.attr('string')
  dialedAt: DS.attr('datetime', key: 'dialed_at')
  endedAt: DS.attr('datetime', key: 'ended_at')
  to: Radium.polymorphic('to')
  from: Radium.polymorphic('from')

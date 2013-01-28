Radium.PhoneCall = Radium.Core.extend Radium.CommentsMixin,
  outcome: DS.attr('string')
  duration: DS.attr('number')
  kind: DS.attr('string')
  dialedAt: DS.attr('datetime')
  endedAt: DS.attr('datetime')

  to: DS.attr('object')
  from: DS.attr('object')

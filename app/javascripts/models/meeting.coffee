Radium.Meeting = Radium.Core.extend Radium.CommentsMixin,
  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  user: DS.belongsTo('Radium.User')

  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

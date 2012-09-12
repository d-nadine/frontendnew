Radium.Meeting = Radium.Core.extend
  isEditable: true
  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime', key: 'starts_at')
  endsAt: DS.attr('datetime', key: 'ends_at')
  user: DS.belongsTo('Radium.User', key: 'user')
  users: DS.hasMany('Radium.User', key: 'user_ids')
  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  associatedUsers: Radium.defineFeedAssociation(Radium.User, 'user')

  feedDate: (-> @get 'startsAt' ).property('startsAt')

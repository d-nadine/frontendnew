Radium.Meeting = Radium.Core.extend Radium.CommentsMixin,
  isEditable: true
  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')
  user: DS.belongsTo('Radium.User')
  users: DS.hasMany('Radium.User', key: 'user_ids')
  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  associatedUsers: Radium.defineFeedAssociation(Radium.User, 'user')

  feedDate: (-> @get 'startsAt' ).property('startsAt')

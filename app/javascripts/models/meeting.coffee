Radium.Meeting = Radium.Core.extend Radium.CommentsMixin,
  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')
  user: DS.belongsTo('Radium.User')
  users: DS.hasMany('Radium.User', key: 'user_ids')
  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  todos: DS.hasMany('Radium.Todo', inverse: 'meeting')

  feedDate: (-> @get 'startsAt' ).property('startsAt')

  # FIXME: Can we rename topic to description
  description: ( ->
    @get('topic')
  ).property('topic')

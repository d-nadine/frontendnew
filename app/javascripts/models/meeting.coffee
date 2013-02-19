Radium.Meeting = Radium.Model.extend Radium.CommentsMixin, 
  Radium.AttachmentsMixin,

  user: DS.belongsTo('Radium.User')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  time: Ember.computed.alias('startsAt')

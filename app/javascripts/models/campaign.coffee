Radium.Campaign = Radium.Core.extend Radium.CommentsMixin,
  name: DS.attr('string')
  endsAt: DS.attr('datetime')
  currency: DS.attr('string')
  target: DS.attr('number')
  isPublic: DS.attr('boolean')
  user: DS.belongsTo('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  todos: DS.hasMany('Radium.Todo', inverse: 'campaign')
  notifications: DS.hasMany('Radium.Notification', inverse: 'reference')

  associatedUsers: Radium.defineFeedAssociation(Radium.User, 'user')

  feedDate: (->
    @get('endsAt')
  ).property('endsAt')

Radium.Contact = Radium.Model.extend Radium.FollowableMixin, 
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')
  deals: DS.hasMany('Radium.Deal')
  followers: DS.hasMany('Radium.User', inverse: null)
  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')
  isLead: DS.attr('boolean')
  source: DS.attr('string')

  phoneNumbers: DS.attr('array')

  avatar: DS.attr('object')

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

Radium.Contact = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')
  deals: DS.hasMany('Radium.Deal')
  followers: DS.hasMany('Radium.User', inverse: null)
  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  phoneNumbers: DS.attr('array')
  emailAddresses: DS.attr('array')
  status: DS.attr('string')

  source: DS.attr('string')

  status: DS.attr('string')

  title: DS.attr('string')

  phoneNumbers: DS.attr('array')

  avatar: DS.attr('object')

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  isLead: ( ->
    @get('status') == 'lead'
  ).property('status')


Radium.Contact = Radium.Model.extend Radium.FollowableMixin,
  name: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')
  status: DS.attr('string')
  source: DS.attr('string')

  avatar: DS.attr('object')

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')
  deals: DS.hasMany('Radium.Deal')

  user: DS.belongsTo('Radium.User')

  nextTask: DS.attr('object')

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

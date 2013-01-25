Radium.Contact = Radium.Person.extend Radium.FollowableMixin,
  status: DS.attr("string")
  user: DS.belongsTo('Radium.User')
  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')
  deals: DS.hasMany('Radium.Deal')
  source: DS.attr('string')

  displayName: (->
    @get('name') || @get('email') || @get('phoneNumber')
  ).property('name', 'email', 'phoneNumber')

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

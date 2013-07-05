Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  account: DS.belongsTo('Radium.Account')

  # FIXME: Temporary hack
  # deals: DS.hasMany('Radium.Deal')

  # FIXME: Temporary hack
  deals: ( ->
    Radium.Deal.filter (deal) =>
      deal.get('user') == this
  ).property()

  todos: DS.hasMany('Radium.Todo', inverse: 'user')
  calls: DS.hasMany('Radium.Call', inverse: 'user')
  meetings: DS.hasMany('Radium.Meeting', inverse: 'users')

  activities: DS.hasMany('Radium.Activity', inverse: 'user')

  firstName: DS.attr('string')
  lastName: DS.attr('string')
  title: DS.attr('string')

  following: DS.hasMany('Radium.User')

  email: DS.attr('string')
  phone: DS.attr('string')

  avatar: DS.attr('object')

  settings: DS.attr('object')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  salesGoal: DS.attr('number')

  name: ( ->
    "#{@get("firstName")} #{@get("lastName")}"
  ).property('firstName', 'lastName')

  contacts: ( ->
    # FIXME: remove filter when deals are populated
    Radium.Contact.filter (contact) =>
      contact.get('user') == this
    # return unless @get('deals.length')

    # @get('deals').map((deal) =>
    #   deal.get('contact') unless deal.get('isUnpublished')
    # ).uniq()
  ).property('deals.[]')

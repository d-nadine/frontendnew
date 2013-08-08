Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  settings: DS.belongsTo('Radium.UserSettings')
  account: DS.belongsTo('Radium.Account')

  deals: DS.hasMany('Radium.Deal')

  todos: DS.hasMany('Radium.Todo', inverse: 'user')
  calls: DS.hasMany('Radium.Call', inverse: 'user')
  meetings: DS.hasMany('Radium.Meeting', inverse: 'users')

  activities: DS.hasMany('Radium.Activity', inverse: 'user')

  firstName: DS.attr('string')
  lastName: DS.attr('string')
  title: DS.attr('string')
  isAdmin: DS.attr('boolean')

  following: DS.hasMany('Radium.User')

  email: DS.attr('string')
  phone: DS.attr('string')

  avatar: DS.attr('object')

  lastLogin: DS.attr('date')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  salesGoal: DS.attr('number')

  token: DS.attr('string')

  name: ( ->
    "#{@get("firstName")} #{@get("lastName")}"
  ).property('firstName', 'lastName')

  contacts: ( ->
    Radium.Contact.all().filter (contact) =>
      contact.get('user') == this
  ).property('deals.[]')

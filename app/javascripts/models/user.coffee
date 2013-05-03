Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  contacts: DS.hasMany('Radium.Contact')
  deals: DS.hasMany('Radium.Deal')

  todos: DS.hasMany('Radium.Todo', inverse: 'user')
  calls: DS.hasMany('Radium.Call', inverse: 'user')
  meetings: DS.hasMany('Radium.Meeting')

  firstName: DS.attr('string')
  lastName: DS.attr('string')

  name: ( ->
    "#{@get("firstName")} #{@get("lastName")}"
  ).property('firstName', 'lastName')

  email: DS.attr('string')
  phone: DS.attr('string')

  title: DS.attr('string')

  avatar: DS.attr('object')

  settings: DS.attr('object')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')


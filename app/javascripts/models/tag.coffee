Radium.Tag = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  activities: DS.hasMany('Radium.Activity')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  name: DS.attr('string')

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')
  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  contacts: DS.hasMany('Radium.Contact')
  deals: DS.hasMany('Radium.Deal')

  todos: DS.hasMany('Radium.Todo', inverse: 'user')
  meetings: DS.hasMany('Radium.Meeting')

  name: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')

  title: DS.attr('string')

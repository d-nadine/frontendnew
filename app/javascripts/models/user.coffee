Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  name: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')

  contacts: DS.hasMany('Radium.Contact')
  discussions: DS.hasMany('Radium.User')
  comments: DS.hasMany('Radium.Comment')

Radium.Tag = Radium.Model.extend Radium.FollowableMixin,
  activities: DS.hasMany('Radium.Activity')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  name: DS.attr('string')

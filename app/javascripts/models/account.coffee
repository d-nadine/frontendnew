Radium.Account = Radium.Core.extend
  name: DS.attr('string')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  avatar: DS.attr('string')

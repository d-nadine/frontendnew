Radium.Account = Radium.Core.extend
  name: DS.attr('string')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  campaigns: DS.hasMany('Radium.Campaign')
  avatar: DS.attr('string')

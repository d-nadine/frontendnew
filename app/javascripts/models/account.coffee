Radium.Account = Radium.Model.extend
  settings: DS.attr('object')
  users: DS.hasMany('Radium.User')

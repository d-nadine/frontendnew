Radium.UserSettings = Radium.Model.extend
  signature: DS.attr('string')
  users: DS.hasMany('Radium.User')

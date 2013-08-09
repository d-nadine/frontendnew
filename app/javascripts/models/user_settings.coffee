Radium.UserSettings = Radium.Model.extend
  signature: DS.attr('string')
  users: DS.hasMany('Radium.User')
  notifications: DS.belongsTo('Radium.NotificationSettings')

Radium.UserSettings = Radium.Model.extend
  signature: DS.attr('string')
  notifications: DS.belongsTo('Radium.NotificationSettings')
  alerts: DS.belongsTo('Radium.Alerts')
  enableOpenTracking: DS.attr('boolean')
  enableClickTracking: DS.attr('boolean')

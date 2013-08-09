Radium.UserNotificationSetting = Radium.Model.extend
  enabled: DS.attr('boolean')
  duration: DS.attr('number')
  notificationSettings: DS.hasMany('Radium.NotificationSettings')

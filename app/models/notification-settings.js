import Model from 'radium/models/models';

const NotificationSettings = Model.extend({
  overdueTasks: DS.belongsTo("Radium.UserNotificationSetting"),
  createdOverdueTasks: DS.belongsTo("Radium.UserNotificationSetting"),
  localMeetings: DS.belongsTo("Radium.UserNotificationSetting"),
  remoteMeetings: DS.belongsTo("Radium.UserNotificationSetting"),
  leadIgnored: DS.belongsTo("Radium.UserNotificationSetting"),
  clientIgnored: DS.belongsTo("Radium.UserNotificationSetting"),
  taskIgnored: DS.belongsTo("Radium.UserNotificationSetting")
});

export default NotificationSettings;

NotificationSettings.toString = function() {
  return "Radium.NotificationSettings";
};
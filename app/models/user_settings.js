import Model from 'radium/models/models';

const UserSettings = Model.extend({
  signature: DS.attr('string'),
  notifications: DS.belongsTo('Radium.NotificationSettings'),
  alerts: DS.belongsTo('Radium.Alerts'),
  enableOpenTracking: DS.attr('boolean'),
  enableClickTracking: DS.attr('boolean')
});

export default UserSettings;

UserSettings.toString = function() {
  return "Radium.UserSettings";
};

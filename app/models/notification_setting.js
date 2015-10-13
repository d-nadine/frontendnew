import Model from 'radium/models/models';

const UserNotificationSetting = Model.extend({
  enabled: DS.attr('boolean'),
  duration: DS.attr('number')
});

export default UserNotificationSetting;

UserNotificationSetting.toString = function() {
  return "Radium.UserNotificationSetting";
};
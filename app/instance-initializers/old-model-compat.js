import SubscriptionPlan from 'radium/models/subscription_plan';
import Billing from 'radium/models/billing';
import Account from 'radium/models/account';
import Alerts from 'radium/models/alerts';
import UserSettings from 'radium/models/user_settings';
import NotificationSettings from 'radium/models/notification_settings';
import UserNotificationSetting from 'radium/models/notification_setting';
import SocialProfile from 'radium/models/social_profile';
import ContactInfo from 'radium/models/contact_info';
import User from 'radium/models/user';

export function initialize(application) {
  // we need to set this reference to the application
  // instance for this version of ember-data
  window.Radium = application;

  application.SubscriptionPlan = SubscriptionPlan;
  application.Billing = Billing;
  application.Account = Account;
  application.Alerts = Alerts;
  application.NotificationSettings = NotificationSettings;
  application.UserNotificationSetting = UserNotificationSetting;
  application.UserSettings = UserSettings;
  application.SocialProfile = SocialProfile;
  application.ContactInfo = ContactInfo;
  application.User = User;
}

export default {
  name: 'old-model-compat',
  initialize: initialize,
  before: 'store-compatibility'
};

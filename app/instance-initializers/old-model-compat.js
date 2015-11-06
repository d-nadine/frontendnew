import SubscriptionPlan from 'radium/models/subscription-plan';
import Billing from 'radium/models/billing';
import Account from 'radium/models/account';
import Alerts from 'radium/models/alerts';
import UserSettings from 'radium/models/user-settings';
import NotificationSettings from 'radium/models/notification-settings';
import UserNotificationSetting from 'radium/models/notification-setting';
import SocialProfile from 'radium/models/social-profile';
import ContactInfo from 'radium/models/contact-info';
import User from 'radium/models/user';
import ConversationsTotals from 'radium/models/conversations-totals';
import ListStatus from 'radium/models/list-status';
import List from 'radium/models/list';
import Email from 'radium/models/email';
import EmailAddress from 'radium/models/email-address';
import PhoneNumber from 'radium/models/phone-number';
import Address from 'radium/models/address';
import Contact from 'radium/models/contact';
import AutocompleteItem from "radium/models/autocomplete-item";
import MarketCategory from 'radium/models/market-category';
import Technology from 'radium/models/technology';
import ContactRef from "radium/models/contact-ref";
import Deal from "radium/models/deal";
import Company from "radium/models/company";

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
  application.ConversationsTotals = ConversationsTotals;
  application.ListStatus = ListStatus;
  application.List = List;
  application.Email = Email;
  application.EmailAddress = EmailAddress;
  application.PhoneNumber = PhoneNumber;
  application.Address = Address;
  application.Contact = Contact;
  application.AutocompleteItem = AutocompleteItem;
  application.MarketCategory = MarketCategory;
  application.Technology = Technology;
  application.ContactRef = ContactRef;
  application.Deal = Deal;
  application.Company = Company;
}

export default {
  name: 'old-model-compat',
  initialize: initialize,
  before: 'store-compatibility'
};

import DS from 'ember-data';
import Model from 'radium/models/models';
import Account from 'radium/models/account';
import Ember from 'ember';

const {
  computed
} = Ember;

const User = Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  title: DS.attr('string'),
  isAdmin: DS.attr('boolean'),
  initialMailImported: DS.attr('boolean'),
  initialContactsImported: DS.attr('boolean'),
  contactsImported: DS.attr('number'),
  emailsImported: DS.attr('number'),
  refreshFailed: DS.attr('boolean'),
  syncState: DS.attr('string'),
  thirdPartyConnected: DS.attr('boolean'),
  shareInbox: DS.attr('boolean'),
  subscriptionInvalid: DS.attr('boolean'),
  email: DS.attr('string'),
  phone: DS.attr('string'),
  avatarKey: DS.attr('string'),
  lastLoggedIn: DS.attr('date'),
  token: DS.attr('string'),

  account: DS.belongsTo('Radium.Account'),
  settings: DS.belongsTo('Radium.UserSettings'),
  contactInfo: DS.belongsTo('Radium.ContactInfo'),

  name: computed('firstName', 'lastName', function() {
    return (this.get("firstName")) + " " + (this.get("lastName"));
  }),
  isSyncing: computed('syncState', function() {
    return this.get('syncState') !== "waiting";
  }),
  displayName: computed.oneWay('name'),
  companyName: computed.oneWay('account.name')
});

User.toString = function(){
  return "Radium.User";
};


export default User;

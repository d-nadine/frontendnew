import Model from 'radium/models/models';
import Ember from 'ember';

const {
  computed
} = Ember;

const {
  attr,
  belongsTo,
  hasMany
} = DS;

const User = Model.extend({
  firstName:               attr('string'),
  lastName:                attr('string'),
  title:                   attr('string'),
  isAdmin:                 attr('boolean'),
  initialMailImported:     attr('boolean'),
  initialContactsImported: attr('boolean'),
  contactsImported:        attr('number'),
  emailsImported:          attr('number'),
  refreshFailed:           attr('boolean'),
  syncState:               attr('string'),
  thirdPartyConnected:     attr('boolean'),
  shareInbox:              attr('boolean'),
  subscriptionInvalid:     attr('boolean'),
  email:                   attr('string'),
  phone:                   attr('string'),
  avatarKey:               attr('string'),
  lastLoggedIn:            attr('date'),
  token:                   attr('string'),

  account:                 belongsTo('Radium.Account'),
  settings:                belongsTo('Radium.UserSettings'),
  contactInfo:             belongsTo('Radium.ContactInfo'),
  
  activities:              hasMany('Radium.Activity', {inverse: 'user'}),

  name: computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  }),
  
  isSyncing: computed('syncState', function() {
    return this.get('syncState') !== 'waiting';
  }),
  
  displayName: computed.oneWay('name'),
  companyName: computed.oneWay('account.name')
});

User.toString = function() {
  return 'Radium.User';
};

export default User;

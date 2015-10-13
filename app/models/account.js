import DS from 'ember-data';
import User from 'radium/models/user';

const Account = DS.Model.extend({
  name: DS.attr('string'),
  users: DS.hasMany('Radium.User'),
  gatewaySetup: DS.attr('boolean'),
  subscriptionInvalid: DS.attr('boolean'),
  isTrial: DS.attr('boolean'),
  trialDaysLeft: DS.attr('number'),
  unlimited: DS.attr('boolean'),
  importedContactsGlobal: DS.attr('boolean'),
  currency: DS.attr('string')
});

export default Account;

Account.toString = function() {
  return 'Radium.Account';
};
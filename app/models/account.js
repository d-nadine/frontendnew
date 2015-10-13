import DS from 'ember-data';
import User from 'radium/models/user';

const Account = DS.Model.extend({
  name: DS.attr('string'),
  gatewaySetup: DS.attr('boolean'),
  subscriptionInvalid: DS.attr('boolean'),
  isTrial: DS.attr('boolean'),
  trialDaysLeft: DS.attr('number'),
  unlimited: DS.attr('boolean'),
  importedContactsGlobal: DS.attr('boolean'),
  currency: DS.attr('string'),

  billing: DS.belongsTo('Radium.Billing'),
  users: DS.hasMany('Radium.User')
});

export default Account;

Account.toString = function() {
  return 'Radium.Account';
};
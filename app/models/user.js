import DS from 'ember-data';
import Account from 'radium/models/account';

const User = DS.Model.extend({
  account: DS.belongsTo('Radium.Account'),
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  title: DS.attr('string'),
  isAdmin: DS.attr('boolean'),
  email: DS.attr('string'),
  avatarKey: DS.attr('string')
});

User.toString = function(){
  return "Radium.User";
};


export default User;

import Model from 'radium/models/models';

const Email = Model.extend({
  subject: DS.attr('string'),
  message: DS.attr('string'),
  html: DS.attr('string'),
  toContacts: DS.hasMany('Radium.Contact'),
  toUsers: DS.hasMany('Radium.User'),
  sendTime: DS.attr('datetime')
});

export default Email;

Email.toString = function() {
  return "Radium.Email";
};
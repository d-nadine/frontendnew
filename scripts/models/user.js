/**
  @extends {Class} Person
*/
define('models/user', function(require) {
  require('models/person');

  Radium.User = Radium.Person.extend({
    email: DS.attr('string'),
    phone: DS.attr('string'),
    account: DS.attr('integer'),
    contacts: DS.hasMany('Radium.Contact'),
    following: DS.hasMany('Radium.User')
  });
    
});
/**
  @extends {Class} Person
*/

define(function(require) {
  var Person = require('./person');

  Raduim.User = Person.extend({
    email: DS.attr('string'),
    phone: DS.attr('sting'),
    account: DS.attr('number'),
    contacts: DS.toMany(Radium.Contact),
    following: DS.toMany(Radium.User)
  });
  
});
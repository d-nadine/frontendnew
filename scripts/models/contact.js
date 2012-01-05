/**
  @extends {Class} Person
*/

define(function(require) {
  var Person = require('./person');

  Radium.Contact = Person.extend({
    addresses: DS.toMany(Radium.Address, {embedded: true}),
    phone_numbers: DS.toMany(Radium.PhoneNumber, {embedded: true}),
    email_addresses: DS.toMany(Radium.Email, {embedded: true}),
    fields: DS.toMany(Radium.CustomField, {embedded: true}),
    user: DS.attr('number')
  });

});
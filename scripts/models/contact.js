/**
  @extends {Class} Person
*/

define('models/contact', function(require) {
  require('models/person');
  
  Radium.Contact = Radium.Person.extend({
    addresses: DS.hasMany(Radium.Address, {embedded: true}),
    phone_numbers: DS.hasMany(Radium.PhoneNumber, {embedded: true}),
    email_addresses: DS.hasMany(Radium.EmailAddress, {embedded: true}),
    fields: DS.hasMany(Radium.CustomField, {embedded: true}),
    user: DS.hasOne(Radium.User)
  });

});
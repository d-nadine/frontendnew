/**
  @extends {Class} Person
*/

define('models/contact', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('models/person');
  require('models/address');
  require('models/phonenumber');
  require('models/emailaddr');
  require('models/customfield');
  
  Radium.Contact = Radium.Person.extend({
    addresses: DS.hasMany(Radium.Address, {embedded: true}),
    phoneNumbers: DS.hasMany(Radium.PhoneNumber, {
      embedded: true,
      key: 'phone_numbers'
    }),
    emailAddresses: DS.hasMany(Radium.EmailAddress, {
      embedded: true,
      key: 'email_addresses'
    }),
    fields: DS.hasMany(Radium.Field, {embedded: true}),
    user: DS.hasOne('Radium.User')
  });

  return Radium;
});
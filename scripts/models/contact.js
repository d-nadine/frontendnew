/**
  @extends {Class} Person
*/

define(function(require) {
  require('./person');

  Radium.Contact = Radium.Person.extend({
    addresses: DS.hasMany(Radium.Address, {embedded: true}),
    phone_numbers: DS.hasMany(Radium.PhoneNumber, {embedded: true}),
    email_addresses: DS.hasMany(Radium.Email, {embedded: true}),
    fields: DS.hasMany(Radium.CustomField, {embedded: true}),
    // TODO: Get hasOne up in this club
    user: DS.hasMany(Radium.User)
  });

});
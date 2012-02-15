/**
  @extends {Class} Person
*/

Radium.Contact = Radium.Person.extend({
  status: DS.attr('string'),
  addresses: DS.hasMany('Radium.Address', {embedded: true}),
  phoneNumbers: DS.hasMany('Radium.PhoneNumber', {
    embedded: true,
    key: 'phone_numbers'
  }),
  emailAddresses: DS.hasMany('Radium.EmailAddress', {
    embedded: true,
    key: 'email_addresses'
  }),
  fields: DS.hasMany('Radium.Field', {embedded: true}),
  user: DS.hasOne('Radium.User')
});
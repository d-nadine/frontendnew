/**
  @extends {Class} Person
*/

Radium.Contact = Radium.Person.extend({
  status: DS.attr('string', {
    defaultValue: 'prospect'
  }),
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
  user: DS.hasOne('Radium.User'),
  // For checkboxes
  isSelected: false,

  // Filter properties
  assigned: function() {
    return (this.get('user')) ? true : false;
  }.property('user').cacheable(),
  
  noUpcomingTasks: function() {
    return (this.get('todos')) ? true : false;
  }.property('todos').cacheable()
});
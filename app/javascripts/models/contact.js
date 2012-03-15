/**
  @extends {Class} Person
*/

Radium.Contact = Radium.Person.extend({
  contactedAt: DS.attr('date', {
    key: 'contacted_at'
  }),
  becameLeadAt: DS.attr('date', {
    key: 'became_lead_at'
  }),
  becameProspectAt: DS.attr('date', {
    key: 'became_prospect_at'
  }),
  becameOpportunityAt: DS.attr('date', {
    key: 'became_opportunity_at'
  }),
  becameCustomerAt: DS.attr('date', {
    key: 'became_customer_at'
  }),
  becameDeadEndAt: DS.attr('date', {
    key: 'became_dead_end_at'
  }),
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
  user: DS.hasOne('Radium.User'),
  // For checkboxes
  isSelected: false,

  // Filter properties
  assigned: function() {
    return (this.get('user')) ? true : false;
  }.property('user').cacheable(),
  
  noUpcomingTasks: function() {
    return (this.get('todos')) ? true : false;
  }.property('todos').cacheable(),

  firstLetter: function() {
    if (this.get('name')) {
      return this.get('name').charAt(0).toUpperCase();  
    } else {
      return "";
    }
  }.property('name').cacheable()
});
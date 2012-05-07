/**
  @extends {Class} Person
*/
Radium.User = Radium.Person.extend({
  apiKey: DS.attr('string', {
    key: 'api_key'
  }),
  email: DS.attr('string'),
  phone: DS.attr('string'),
  account: DS.attr('number'),
  contacts: DS.hasMany('Radium.Contact'),
  following: DS.hasMany('Radium.User'),
  feed: null,
  campaign: DS.belongsTo('Radium.Campaign'),
  leads: function() {
    var contacts = this.get('contacts');
    return contacts.filterProperty('status', 'lead');
  }.property('contacts').cacheable(),
  prospects: function() {
    var contacts = this.get('contacts');
    return contacts.filterProperty('status', 'prospect');
  }.property('contacts').cacheable(),
  pendingDeals: function() {
    var deals = this.get('deals');
    return deals.filterProperty('state', 'pending');
  }.property('deals').cacheable(),
  closedDeals: function() {
    var deals = this.get('deals');
    return deals.filterProperty('state', 'closed');
  }.property('deals').cacheable(),
  paidDeals: function() {
    var deals = this.get('deals');
    return deals.filterProperty('state', 'paid');
  }.property('deals').cacheable(),
  rejectedDeals: function() {
    var deals = this.get('deals');
    return deals.filterProperty('state', 'rejected');
  }.property('deals').cacheable(),
  
  isLoggedIn: function() {
    // Check via API key property or cookie for session id.
    return (this.get('apiKey') || this.get('id') === CONFIG.userId) ? true : false;
  }.property('apiKey').cacheable()
});
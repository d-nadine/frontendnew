/**
  @extends {Class} Person
*/
Radium.User = Radium.Person.extend({
  apiKey: DS.attr('string', {
    key: 'api_key'
  }),
  avatar: DS.attr('object'),
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
    return (this.get('apiKey')) ? true : false;
  }.property('apiKey').cacheable()
});

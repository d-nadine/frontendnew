define('models/campaign', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Campaign = Radium.Core.extend({
    name: DS.attr('string'),
    description: DS.attr('string'),
    ends_at: DS.attr('date'),
    currency: DS.attr('string'),
    target: DS.attr('integer'),
    user: DS.hasOne('Radium.User'),
    is_public: DS.attr('boolean'),
    contacts: DS.hasMany('Radium.Contact'),
    todos: DS.hasMany('Radium.Todo'),
    deals: DS.hasMany('Radium.Deal'),
    phone_calls: DS.hasMany('Radium.PhoneCall'),
    messages: DS.hasMany('Radium.Message'),
    groups: DS.hasMany('Radium.Group'),
    products: DS.hasMany('Radium.Product'),
    users: DS.hasMany('Radium.User'),
    followers: DS.hasMany('Radium.User'),
    notes: DS.hasMany('Radium.Note'),
    meetings: DS.hasMany('Radium.Meeting'),
    activities: DS.hasMany('Radium.Activity'),

    contact_ids: function() {
      return this.get('contacts').getEach('id');
    }.property('contacts').cacheable()
  });
  
  return Radium;
});
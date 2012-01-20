define('models/group', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.Group = Radium.Core.extend({
    name: DS.attr('string'),
    email: DS.attr('string'),
    phone: DS.attr('string'),
    is_public: DS.attr('boolean'),
    fields: DS.hasMany('Radium.Field'),
    todos: DS.hasMany('Radium.Todo'),
    deals: DS.hasMany('Radium.Deal'),
    messages: DS.hasMany('Radium.Message'),
    notes: DS.hasMany('Radium.Note'),
    phone_calls: DS.hasMany('Radium.PhoneCall'),
    meetings: DS.hasMany('Radium.Meeting'),
    campaigns: DS.hasMany('Radium.Campaign'),
    users: DS.hasMany('Radium.User'),
    contacts: DS.hasMany('Radium.Contact'),
    activities: DS.hasMany('Radium.Activity'),
    user: DS.hasOne('Radium.User'),

    contact_ids: function() {
      return this.get('contacts').getEach('id');
    }.property('contacts').cacheable()
  });
  
  return Radium;
});
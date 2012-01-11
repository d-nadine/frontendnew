define('models/group', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Group = Radium.Core.extend({
    name: DS.attr('string'),
    email: DS.attr('string'),
    phone: DS.attr('string'),
    is_public: DS.attr('boolean'),
    fields: DS.hasMany(Radium.Field),
    contacts: DS.hasMany(Radium.Contact),
    todos: DS.hasMany(Radium.Todo),
    deals: DS.hasMany(Radium.Deal),
    messages: DS.hasMany(Radium.Message),
    notes: DS.hasMany(Radium.Note),
    phone_calls: DS.hasMany(Radium.PhoneCall),
    meetings: DS.hasMany(Radium.Meeting),
    campaigns: DS.hasMany(Radium.Campaign),
    users: DS.hasMany(Radium.User),
    activities: DS.hasMany(Radium.Activity)
  });
  
  return Radium;
});
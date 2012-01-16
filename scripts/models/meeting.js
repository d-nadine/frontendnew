define('models/meeting', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Meeting = Radium.Core.extend({
    topic: DS.attr('string'),
    location: DS.attr('string'),
    starts_at: DS.attr('date'),
    ends_at: DS.attr('date'),
    user: DS.hasOne('Radium.User'),
    contacts: DS.hasMany('Radium.Contact'),
    users: DS.hasMany('Radium.User'),
    activities: DS.hasMany('Radium.Activity'),
    invitations: DS.hasMany('Radium.Invitation')
    
  });
  
  return Radium;
});
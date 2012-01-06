define('models/meeting', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.Meeting = Radium.Core.extend({
    topic: DS.attr('string'),
    location: DS.attr('string'),
    starts_at: DS.attr('date'),
    ends_at: DS.attr('date'),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User),
    contacts: DS.hasMany(Radium.Contact),
    users: DS.hasMany(Radium.User),
    activities: DS.hasMany(Radium.Activity),
    invitations: DS.hasMany(Radium.Invitation)
    
  });
  
});
define('models/meeting', function(require) {
  require('ember');
  require('data');
  
  Radium.Meeting = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
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
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
    invitations: DS.hasMany('Radium.Invitation', {
      embedded: true
    }),

    // Client side only, so user can choose to decline a meeting.
    cancelled: DS.attr('boolean'),

    // Compute whether or not we're sending /meetings/{id}/cancel
    // or /meetings/{id}/reschedule
    url: function() {
      return (this.get('cancelled')) ?
         "/meetings/%@/cancel" : 
         "/meetings/%@/reschedule"
    }.property('cancelled')
    
  });
  
  return Radium;
});
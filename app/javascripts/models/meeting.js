Radium.Meeting = Radium.Core.extend({
  isEditable: true,
  type: 'meeting',
  topic: DS.attr('string'),
  location: DS.attr('string'),
  startsAt: DS.attr('datetime', {key: 'starts_at'}),
  endsAt: DS.attr('datetime', {key: 'ends_at'}),
  user: DS.belongsTo('Radium.User', {key: 'user'}),
  contacts: DS.hasMany('Radium.Contact'),
  users: DS.hasMany('Radium.User'),
  notes: DS.hasMany('Radium.Note', {embedded: true}),
  activities: DS.hasMany('Radium.Activity'),
  invitations: DS.hasMany('Radium.Invitation', {
    embedded: true
  }),
  invite: DS.attr('array'),
  comments: DS.hasMany('Radium.Comment'),
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
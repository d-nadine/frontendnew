Radium.Owner = DS.Model.extend({
  user: DS.hasOne('Radium.User', {embedded: true}),
  contact: DS.hasOne('Radium.Contact', {embedded: true})
});

Radium.ActivityType = DS.Model.extend({
  todo: DS.hasOne('Radium.Todo', {embedded: true}),
  deal: DS.hasOne('Radium.Deal', {embedded: true}),
  message: DS.hasOne('Radium.Message', {embedded: true}),
  campaign: DS.hasOne('Radium.Campaign', {embedded: true}),
  contact: DS.hasOne('Radium.Contact', {embedded: true}),
  group: DS.hasOne('Radium.Group', {embedded: true})
});

Radium.Activity = Radium.Core.extend({
  tags: DS.attr('array'),
  timestamp: DS.attr('date'),
  owner: DS.hasOne('Radium.Owner', {embedded: true}),
  reference: DS.hasOne('Radium.ActivityType', {embedded: true}),
  activityType: function() {
    if (this.getPath('data.reference.todo')) return "todo";
    if (this.getPath('data.reference.deal')) return "deal";
    if (this.getPath('data.reference.meeting')) return "meeting";
    if (this.getPath('data.reference.campaign')) return "campaign";
    if (this.getPath('data.reference.message')) return "message";
    if (this.getPath('data.reference.call_list')) return "calllist";
    if (this.getPath('data.reference.announcement')) return "announcement";
  }.property('data').cacheable(),
  
});
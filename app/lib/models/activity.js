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
  // @returns {Ember.DateTime}
  rawDate: function() {
    return new Date(this.get('timestamp')).getTime();
  }.property('timestamp').cacheable(),
  date: function() {
    var date = new Date(this.get('timestamp')).getTime();
    return Ember.DateTime.create(date);
  }.property('timestamp').cacheable(),

  day: function() {
    return this.get('date').toFormattedString('%Y-%m-%d');
  }.property('date').cacheable(),

  week: function() {
    return this.get('date').toFormattedString('%Y-%W');
  }.property('date').cacheable(),

  month: function() {
    return this.get('date').toFormattedString('%Y-%m');
  }.property('date').cacheable(),

  // Bind to the `timestamp` property instead of `time` property so we can 
  // calculate what quarter we're in.
  quarter: function() {
    var quarter,
        date = this.get('timestamp'),
        month = new Date(date).getMonth() + 1;
      if (month <= 3) { quarter = 1; }
      if (month > 3 && month <= 6) { quarter = 2; }
      if (month > 6 && month <= 9) { quarter = 3; }
      if (month > 9 && month <= 12) { quarter = 4; }
    return this.get('date').toFormattedString('%Y-Q') + quarter;
  }.property('timestamp').cacheable(),
  
  year: function() {
    return this.get('date').toFormattedString('%Y');
  }.property('date').cacheable()
});
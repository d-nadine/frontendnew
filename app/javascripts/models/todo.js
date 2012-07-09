Radium.Todo = Radium.Core.extend({
  isEditable: true,
  hasAnimation: false,
  // TODO: Can we just get this through Ember?
  type: 'todo',
  referenceType: function() {
    var ref = this.getPath('data.reference'),
        keys = (ref) ? Ember.keys(ref) : [];
    return (keys.length) ? keys[0] : null;
  }.property('data.reference'),
  kind: DS.attr('todoKind'),
  description: DS.attr('string'),
  finishBy: DS.attr('datetime', {
    key: 'finish_by'
  }),
  finished: DS.attr('boolean'),
  campaign: DS.belongsTo('Radium.Campaign'),
  callList: DS.belongsTo('Radium.CallList', {
    key: 'call_list'
  }),
  isCall: function() {
    return (this.get('kind') === 'call') ? true : false;
  }.property('kind'),
  contact: DS.belongsTo('Radium.Contact', {
    embedded: true
  }),
  contacts: DS.hasMany('Radium.Contact'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),
  notes: DS.hasMany('Radium.Note', {embedded: true}),
  overdue: DS.attr('boolean'),
  reference: DS.attr('object'),
  user: DS.belongsTo('Radium.User', {
    key: 'user'
  }),
  user_id: DS.attr('number'),
  activity: DS.belongsTo('Radium.Activity', {
    embedded: true
  }),

  // Turn on when todo's are created from the form
  hasNotificationAnim: DS.attr('boolean'),

  isDueToday: function() {
    var today = Ember.DateTime.create(),
        finishBy = this.get('finishBy');
    return Ember.DateTime.compareDate(today, finishBy) === 0;
  }.property('finishBy'),

  canComplete: function() {
    return (this.getPath('user.apiKey')) ? true : false;
  }.property('user'),

  canEdit: function() {
    return (this.getPath('user.apiKey') && !this.get('finished')) ? true : false;
  }.property('user', 'finished'),

  reminders_attributes: DS.attr('object')
});
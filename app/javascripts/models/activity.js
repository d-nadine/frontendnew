Radium.Activity = Radium.Core.extend({
  tag: DS.attr('string'),
  kind: DS.attr('string'),
  timestamp: DS.attr('date'),
  owner: DS.attr('object'),
  user: DS.hasOne('Radium.User', {
    embedded: true
  }),
  reference: DS.attr('object'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),

  // Embedded models
  todo: DS.hasOne('Radium.Todo', {embedded: true}),
  // todo: DS.attr('object'),
  deal: DS.hasOne('Radium.Deal', {embedded: true}),
  message: DS.hasOne('Radium.Message', {embedded: true}),
  email: DS.hasOne('Radium.Email', {embedded: true}),
  campaign: DS.hasOne('Radium.Campaign', {embedded: true}),
  contact: DS.hasOne('Radium.Contact', {embedded: true}),
  group: DS.hasOne('Radium.Group', {embedded: true}),
  meeting: DS.hasOne('Radium.Meeting', {embedded: true}),
  phoneCall: DS.hasOne('Radium.PhoneCall', {
    embedded: true,
    key: 'phone_call'
  }),

  isCall: function() {
    if (this.get('reference').hasOwnProperty('todo')) {
      return this.getPath('reference.todo.kind') === 'call';
    } else {
      return false;
    }
  }.property('reference.todo.kind').cacheable(),

  isTodoFinished: function() {
    return this.get('tag') === 'finished';
  }.property('tag').cacheable()
});
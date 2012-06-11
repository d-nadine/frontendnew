Radium.Activity = Radium.Core.extend({
  tag: DS.attr('string'),
  kind: DS.attr('string'),
  timestamp: DS.attr('datetime'),
  owner: DS.attr('object'),
  user: DS.belongsTo('Radium.User'),
  reference: DS.attr('object'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),

  // Embedded models
  todo: DS.belongsTo('Radium.Todo', {embedded: true}),
  deal: DS.belongsTo('Radium.Deal', {embedded: true}),
  message: DS.belongsTo('Radium.Message', {embedded: true}),
  email: DS.belongsTo('Radium.Email', {embedded: true}),
  campaign: DS.belongsTo('Radium.Campaign', {embedded: true}),
  contact: DS.belongsTo('Radium.Contact', {embedded: true}),
  group: DS.belongsTo('Radium.Group', {embedded: true}),
  meeting: DS.belongsTo('Radium.Meeting', {embedded: true}),
  phoneCall: DS.belongsTo('Radium.PhoneCall', {
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
  }.property('tag').cacheable(),
  dateLabel: function(){
    return this.get('timestamp').toFormattedString("%Y-%m-%d"); 
  }.property('timestamp')
});

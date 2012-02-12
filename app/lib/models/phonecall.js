Radium.PhoneCall = Radium.Core.extend({
  outcome: DS.attr('string'),
  duration: DS.attr('integer'),
  kind: DS.attr('string'),
  dialed_at: DS.attr('date'),
  to: DS.attr('object'),
  from: DS.attr('object'),
  contacts: DS.hasMany('Radium.Contact'),
  users: DS.hasMany('Radium.User'),
  comments: DS.hasMany('Radium.Comment'),
  todos: DS.hasMany('Radium.Todo'),
  // For now, the best we can do is strip out the ID's
  callTo: function() {
    return this.get('to').getEach('id');
  }.property('to').cacheable(),

  callFrom: function() {
    return this.get('from').getEach('id');
  }.property('from').cacheable(),
});
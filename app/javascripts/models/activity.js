Radium.Activity = Radium.Core.extend({
  tag: DS.attr('string'),
  kind: DS.attr('string'),
  timestamp: DS.attr('datetime'),
  owner: DS.attr('object'),
  user: DS.belongsTo('Radium.User'),
  // Embedded key only
  reference: DS.attr('object'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
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
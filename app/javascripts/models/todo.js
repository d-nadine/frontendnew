Radium.Todo = Radium.Core.extend({
  kind: DS.attr('todoKind'),
  description: DS.attr('string'),
  finishBy: DS.attr('date', {
    key: 'finish_by'
  }),
  sortValue: function() {
    return new Date(this.get('updatedAt')).getTime();
  }.property('finishBy').cacheable(),
  finished: DS.attr('boolean'),
  campaign: DS.hasOne('Radium.Campaign'),
  callList: DS.hasOne('Radium.CallList', {
    key: 'call_list'
  }),
  contacts: DS.hasMany('Radium.Contact'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),
  user: DS.hasOne('Radium.User', {
    embedded: true
  }),
  user_id: DS.attr('number'),

  /**
    Checks to see if the Deal has passed it's close by date.
    @return {Boolean}
  */
  isOverdue: function() {
    var d = new Date().getTime(),
        isFinished = this.get('finished'),
        finishBy = new Date(this.get('finishBy')).getTime();
    return (finishBy <= d && !isFinished) ? true : false;
  }.property('finishBy', 'finished').cacheable()
});
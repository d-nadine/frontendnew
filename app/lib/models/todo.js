Radium.Todo = Radium.Core.extend({
  kind: DS.attr('todoKind'),
  description: DS.attr('string'),
  finishBy: DS.attr('date', {
    key: 'finish_by'
  }),
  finished: DS.attr('boolean'),
  campaign: DS.hasOne('Radium.Campaign'),
  callList: DS.hasOne('Radium.CallList', {
    key: 'call_list'
  }),
  // TODO: Set up this as an embedded object possibly... variable toOne not supported
  // reference: DS.hasOne('Radium.', {
  //   embedded: true
  // }),
  contacts: DS.hasMany('Radium.Contact'),
  comments: DS.hasMany('Radium.Comment'),
  user: DS.hasOne('Radium.User'),

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
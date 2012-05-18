Radium.Todo = Radium.Core.extend({
  kind: DS.attr('todoKind'),
  description: DS.attr('string'),
  finishBy: DS.attr('datetime', {
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
  isCall: function() {
    return (this.get('kind') === 'call') ? true : false;
  }.property('kind').cacheable(),
  contact: DS.hasOne('Radium.Contact', {
    embedded: true
  }),
  contacts: DS.hasMany('Radium.Contact'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),
  reference: DS.attr('object'),
  user: DS.hasOne('Radium.User', {
    embedded: true
  }),
  user_id: DS.attr('number'),
  activity: DS.hasOne('Radium.Activity', {
    embedded: true
  }),

  // Turn on when todo's are created from the form
  hasNotificationAnim: DS.attr('boolean'),

  isToday: function() {
    var today = Radium.appController.get('today').toFormattedString('%Y-%m-%d'),
        finishBy = this.get('finishBy').toFormattedString('%Y-%m-%d');
    return finishBy === today && !this.get('finished');
  }.property('finishBy').cacheable(),

  canEdit: function() {
    return (this.getPath('user.apiKey')) ? true : false;
  }.property('user', 'finished').cacheable(),

  /**
    Checks to see if the Deal has passed it's close by date.
    @return {Boolean}
  */
  isOverdue: function() {
    var today = Radium.appController.get('today'),
        yesterday = today.advance({day: -1}),
        finishBy = this.get('finishBy');
        
    return Ember.DateTime.compare(today, finishBy) === 1 && !this.get('finished');
  }.property('finishBy', 'finished').cacheable()
});
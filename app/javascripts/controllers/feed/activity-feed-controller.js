Radium.ActivityFeedController = Ember.ArrayProxy.extend({
  init: function(){
    this._super();

    Radium.Activity.reopenClass({
      url: '/users/%@/feed'.fmt(13),
      root: 'activity'
    });

    var start = Ember.DateTime.create();

    this.set('content', Radium.store.find(Radium.Activity, {
          end_date: start.toFormattedString('%Y-%m-%d'), 
          start_date: start.toFormattedString('%Y-%m-%d')
        }));
  }
});

Radium.ActivityFeedController = Ember.ArrayProxy.extend(Radium.FeedScroller, {
  forwardContent: Radium.FutureFeed.create(),
  init: function(){
    this._super();
    this.on('onNewData', this, 'onNewData');
  },
  onNewData: function(){
    Radium.get('appController').toggleKind();
  },

  feedLoaded: function(){
    this.set('previous_activity_date', Radium.getPath('appController.feed.previous_activity_date'));
    this.set('next_activity_date', Radium.getPath('appController.feed.next_activity_date'));
  }.observes('Radium.appController.feed'),

  clustersLoaded: function(){
    var clusters = Radium.getPath('appController.clusters');

    if (clusters) {
      this.set('content', clusters);
    }
  }.observes('Radium.appController.clusters')
});

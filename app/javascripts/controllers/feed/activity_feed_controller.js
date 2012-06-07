Radium.ActivityFeedController = Ember.ArrayProxy.extend(Radium.BatchViewLoader, {
  content: Ember.A(),
  init: function(){
    this._super();
    this.set('view', Ember.ContainerView.create());
  },

  bootstrapLoaded: function(){
    var feed = Radium.getPath('appController.feed');

    if (feed) {
      Radium.store.loadMany(Radium.Activity, feed);
      this.set('content', Radium.store.findMany(Radium.Activity, feed.mapProperty('id').uniq()));
      this.batchloadViews(function(activity){
        if (activity) {
          return Radium.ClusterView.create({
            content: activity,
            templateName: 'cluster_item'
          });
        }
      });
    }
  }.observes('Radium.appController.feed')
});

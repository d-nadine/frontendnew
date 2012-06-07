//TODO rename to ClusterFeedController
Radium.ActivityFeedController = Ember.ArrayProxy.extend(Radium.BatchViewLoader, {
  content: Ember.A(),
  init: function(){
    this._super();
    this.set('view', Ember.ContainerView.create());
  },

  bootstrapLoaded: function(){
    var clusters = Radium.getPath('appController.clusters');

    if (clusters) {
      this.set('content', clusters);
      this.batchloadViews(function(cluster){
        if (cluster) {
          return Radium.ClusterView.create({
            content: cluster,
            templateName: 'cluster_item'
          });
        }
      });
    }
  }.observes('Radium.appController.feed')
});

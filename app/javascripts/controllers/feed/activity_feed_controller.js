Radium.ActivityFeedController = Ember.ArrayProxy.extend({
  content: Ember.A(),
  bootstrapLoaded: function(){
    var feed = Radium.getPath('appController.feed');
    Radium.store.loadMany(Radium.Activity, feed);
    this.set('content', Radium.store.findMany(Radium.Activity, feed.mapProperty('id').uniq()));
  }.observes('Radium.appController.feed')
});

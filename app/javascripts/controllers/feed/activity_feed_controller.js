Radium.ActivityFeedController = Ember.ArrayProxy.extend({
  content: Ember.A(),
  bootstrapLoaded: function(){
    var feed = Radium.getPath('appController.feed');
    Radium.store.loadMany(Radium.Activity, feed);
    var activities = Radium.store.findMany(Radium.Activity, feed.mapProperty('id').uniq()); 
    var grouped = _.emberArrayGroupBy(activities, 'dateLabel');
    this.set('content', Radium.store.findMany(Radium.Activity, feed.mapProperty('id').uniq()));
  }.observes('Radium.appController.feed')
});

_.emberArrayGroupBy = function(emberArray, val) {
  var result = {}, key, value, i, l = emberArray.get('length'),
    iterator = _.isFunction(val) ? val : function(obj) { return obj.get(val); };

  for (i=0; i<l; i++) {
    value = emberArray.objectAt(i);
    key   = iterator(value, i);
    (result[key] || (result[key] = [])).push(value);
  }
  return result;
};

Radium.ActivityFeedController = Ember.ArrayProxy.extend({
  content: Ember.A(),
  sliceStart: 0,
  inc: 25,
  end: function() {
    return this.get('length') - this.get('inc');
  }.property('content.length'),
  _cache: Ember.A([]),

  init: function(){
    this.set('view', Ember.ContainerView.create({
      tagName: 'div'
    }));
  },

  bootstrapLoaded: function(){
    var feed = Radium.getPath('appController.feed');
    Radium.store.loadMany(Radium.Activity, feed);
    this.set('content', Radium.store.findMany(Radium.Activity, feed.mapProperty('id').uniq()));
    var self = this;
    console.time('manualViewCreate');
    this.get('content').forEach(function(activity, idx) {
      var view = Ember.View.create({
        content: activity,
        templateName: activity.get('kind') + '_' + activity.get('tag')
      });
      this.get('_cache').pushObject(view);
    }, this);
    console.timeEnd('manualViewCreate');
    Ember.run.next(function() {
      self.staggeredRendering();
    });
  }.observes('Radium.appController.feed'),

  staggeredRendering: function() {
    var self = this,
        view = this.get('view'),
        itemViews = this.get('_cache'),
        sliceStart = this.get('sliceStart'),
        inc = this.get('inc'),
        sliceEnd = sliceStart + inc,
        end = this.get('end');

    console.time('slide'+sliceStart);
    var chunk = itemViews.slice(sliceStart, sliceEnd);
    this.set('sliceStart', sliceEnd);
    view.get('childViews').pushObjects(chunk);
    console.timeEnd('slide'+sliceStart);

    if (sliceStart < end) {
      Ember.run.next(function() {
        self.staggeredRendering();
      });
    }
  }
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

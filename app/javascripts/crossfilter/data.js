window.Crossfilter = Ember.Namespace.create();

Crossfilter.Data = Ember.Object.extend({
  crossfilter: null,

  // Raw JSON array stored here
  data: null,
  feeds: null,
  // Set via `applyFilter` method for binding with other objects/views
  filter: null,
  
  init: function() {
    this.set('feeds', []);
  },
  // Convenience property to add data to Crossfilter in an Ember-friendly way
  addData: function(data) {
    if (!this._crossfilter) {
      this._crossfilter = crossfilter(data);
      this.get('feeds').setEach('crossfilter', this._crossfilter);
    } else {
      this._crossfilter.add(data);
    }
    this.propertyDidChange('crossfilter');
  },

  registerFeed: function(feed) {
    feed.set('parent', this);
    this.get('feeds').pushObject(feed);
    this.propertyDidChange('crossfilter');
  },

  registerFeeds: function(feeds) {
    feeds.setEach('parent', this);
    this.get('feeds').pushObjects(feeds);
    this.propertyDidChange('crossfilter');
  },

  refreshAll: function() {
    var feeds = this.get('feeds');
    feeds.forEach(function(feed) {
      feed.refresh();
    });
  },

  refreshFeed: function(sender) {
    var feeds = this.get('feeds');
    feeds.forEach(function(feed) {
      if (feed !== sender) {
        feed.refresh();
      }
    });
  },

  size: function() {
    return (this._crossfilter) ? this._crossfilter.size() : 0;
  }.property('crossfilter').cacheable()
});
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
  },

  registerFeed: function(feed) {
    this.get('feeds').pushObject(feed);
    this.propertyDidChange('crossfilter');
  },

  registerFeeds: function(feed) {
    this.get('feeds').pushObjects(feed);
    this.propertyDidChange('crossfilter');
  },

  size: function() {
    return (this._crossfilter) ? this._crossfilter.size() : 0;
  }.property().cacheable()
});
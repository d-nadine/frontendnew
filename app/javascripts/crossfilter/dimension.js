Crossfilter.Dimension = Ember.Object.extend({
  filter: null,
  dimension: null,
  group: null,
  refresh: Ember.K,
  refreshParent: function() {
    var parent = this.get('parent');
    if (parent) {
      parent.refreshFeed(this);
    }
  },
  applyFilter: function() {
    var filter = this.get('filter'),
        dimension = this.get('dimension');
    dimension.filter(filter);
    this.refreshParent();
  }.observes('filter')
});
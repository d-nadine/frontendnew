Radium.ClusterActivityListView = Ember.CollectionView.extend({
  classNames: 'feed-item'.w(),
  itemViewClass: Radium.HistoricalFeedView,
  didInsertElement: function() {
    this.$().hide().slideDown('fast');
  },
  slideUp: function() {
    return this.$().slideUp('fast');
  }
});
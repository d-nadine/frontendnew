Radium.ClusterActivityListView = Ember.CollectionView.extend({
  itemViewClass: Radium.HistoricalFeedView,
  didInsertElement: function() {
    this.$().hide().slideDown('fast');
  },
  slideUp: function() {
    return this.$().slideUp('fast');
  }
});
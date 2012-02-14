Radium.FeedItemBlockView = Ember.View.extend({
  classNames: 'row feed-item'.w(),
  isDetailsVisible: false,
  isVisible: function() {
    var filter = Radium.dashboardController.get('categoryFilter');
    return (this.get(filter) !== undefined || filter === 'everything') ? true : false;
  }.property('Radium.dashboardController.categoryFilter').cacheable()
});
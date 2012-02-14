Radium.ActivitySummaryView = Ember.View.extend({
  classNames: 'row feed-item'.w(),
  isDetailsVisible: false,
  detailsView: Radium.FeedTodosView,
  template: Ember.Handlebars.compile('{{view summaryBox}} {{view detailsView}}'),
  isVisible: function() {
    var filter = Radium.dashboardController.get('categoryFilter');
    return (this.get(filter) !== undefined || filter === 'everything') ? true : false;
  }.property('Radium.dashboardController.categoryFilter').cacheable(),
  summaryBox: Ember.View.extend({
    classNames: 'span9'.w(),
    actionsVisible: false,
    click: function(evt) {
      this.get('parentView').toggleProperty('isDetailsVisible');
    },
    templateName: 'feed_item_block_view'
  })
});
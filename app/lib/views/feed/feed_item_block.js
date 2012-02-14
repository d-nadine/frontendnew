Radium.FeedItemBlockView = Ember.View.extend({
  classNames: ['row', 'feed-item'],
  isDetailsVisible: false,
  isVisible: function() {
    var filter = Radium.dashboardController.get('categoryFilter');
    return (this.get(filter) !== undefined || filter === 'everything') ? true : false;
  }.property('Radium.dashboardController.categoryFilter').cacheable(),
  headlineView: Ember.View.extend({
    classNames: ['span9'],
    actionsVisible: false,
    click: function(evt) {
      this.get('parentView').toggleProperty('isDetailsVisible');
    },
    templateName: 'feed_item_headline'
  })
});
Radium.FeedItemHeadlineView = Ember.View.extend({
  classNames: ['alert', 'alert-block'],
  // Render the template on the fly based on the type of feed item
  templateName: function() {
    return 'feed_headline_' + this.getPath('parentView.filterType');
  }.property().cacheable(),
  actionsVisible: false,
  click: function() {
    this.get('parentView').toggleProperty('isDetailsVisible');
  }
});
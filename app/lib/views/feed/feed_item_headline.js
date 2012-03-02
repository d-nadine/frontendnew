Radium.FeedItemHeadlineView = Ember.View.extend({
  classNames: ['alert', 'alert-block'],
  // Render the template on the fly based on the type of feed item
  templateName: function() {
    return 'feed_headline_' + this.get('type');
  }.property().cacheable(),

  click: function() {
    this.get('parentView').toggleProperty('isDetailsVisible');
  }
});
Radium.FeedItemTodosView = Ember.View.extend({
  isVisible: function() {
    return this.getPath('parentView.isDetailsVisible');
  }.property('parentView.isDetailsVisible'),
  templateName: 'feed_item_todos'
});
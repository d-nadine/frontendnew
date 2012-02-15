Radium.FeedItemBlockView = Ember.View.extend({
  classNames: ['row', 'feed-item'],
  isDetailsVisible: false,
  isVisible: function() {
    var filter = this.get('category');
    return (this.get('filter') === filter || filter === 'everything') ? true : false;
  }.property('category').cacheable()
});
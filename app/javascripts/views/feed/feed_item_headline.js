Radium.FeedItemHeadlineView = Ember.View.extend({
  classNames: ['alert', 'alert-block'],
  // Render the template on the fly based on the type of feed item
  templateName: function() {
    return 'feed_headline_' + this.getPath('parentView.filterType');
  }.property().cacheable(),
  isDetailsVisible: false,
  click: function() {
    var type = this.getPath('parentView.model');

    if (this.get('isDetailsVisible')) {
      this.getPath('parentView.childViews').popObject();
    } else {
      var ids = this.getPath('parentView.ids'),
          items = Radium.store.findMany(Radium[type], ids),
          view = Radium['FeedItem' + type + 'sView'].create();
      this.setPath('parentView.items', items);
      this.getPath('parentView.childViews').pushObject(view);
    }
  },
  childrenAdded: function() {
    if (this.getPath('parentView.childViews.length') === 1) {
      this.set('isDetailsVisible', false);
    } else {
      this.set('isDetailsVisible', true);
    }
  }.observes('parentView.childViews.@each')
});
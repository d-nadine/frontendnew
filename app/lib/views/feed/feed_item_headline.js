Radium.FeedItemHeadlineView = Ember.View.extend({
  classNames: ['alert', 'alert-block'],
  // Render the template on the fly based on the type of feed item
  templateName: function() {
    return 'feed_headline_' + this.getPath('parentView.filterType');
  }.property().cacheable(),
  isDetailsVisible: false,
  click: function() {
    var type = this.getPath('parentView.model');
    console.log('show?', this.get('isDetailsVisible'));
    if (this.get('isDetailsVisible')) {
      this.getPath('parentView.childViews').popObject();
    } else {
      var view = Radium['FeedItem' + type + 'sView'].create();
      this.getPath('parentView.childViews').pushObject(view);
    }
  },
  childrenAdded: function() {
    console.log(this.getPath('parentView.childViews.length'))
    if (this.getPath('parentView.childViews.length') === 1) {
      this.set('isDetailsVisible', false);
    } else {
      this.set('isDetailsVisible', true);
    }
  }.observes('parentView.childViews.@each')
});
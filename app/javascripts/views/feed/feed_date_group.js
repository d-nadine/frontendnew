Radium.FeedDateGroupView = Ember.View.extend({
  // Hide this group if it's children are all hidden
  isVisible: function() {
    var selectedFilter = this.get('categoryFilter'),
        activityTypes = this.get('activityTypes'),
        dateFilter = this.get('dateFilter');

    if (selectedFilter === 'everything' || activityTypes.indexOf(selectedFilter) > -1) {
      return true;
    } else {
      return false;
    }
  }.property('categoryFilter', 'activityTypes', 'dateFilter').cacheable(),

  tagger: function() {
    console.log(this.getEach('tags'));
  }.property('@each.tags').cacheable()
});
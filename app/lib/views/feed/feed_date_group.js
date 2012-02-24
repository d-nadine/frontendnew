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
  // Groups the activities that belong to the date group
  groups: function() {
    var group = this.get('group').toString(),
        activities = this.get('content'),
        dateType = this.get('dateFilter');
    return activities.filterProperty(dateType, group);
  }.property('group', 'content', 'dateFilter').cacheable()

});

// Each date group's content
Radium.TestFeedItemView = Ember.View.extend({
  // Bind visibility to the selected category
  isVisible: function() {
    var category = this.getPath('parentView.categoryFilter'),
        type = this.get('filterType');
    if (category === type || category === 'everything') {
      return true;
    } else {
      return false;
    }
  }.property('parentView.categoryFilter', 'filterType').cacheable(),

  // If the `this.itemsView` containing all the details is visible or not
  isDetailsVisible: false
});
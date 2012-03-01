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
  }.property('categoryFilter', 'activityTypes', 'dateFilter').cacheable()
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
  isDetailsVisible: false,
  nestedView: null,
  click: function() {
    var type = this.get('type').toString();
    var ids = this.get('ids');
    console.log('ids', ids);
    var deets = Radium.store.findMany(Radium.Todo, ids);
    if (this.get('isDetailsVisible') && this.get('nestedView')) {
      var test = this.get('nestedView');
      test.remove();
      this.set('nestedView', null);
      this.set('isDetailsVisible', false);
    } else {
      var view = Radium.FeedItemTodosView.create();
      this.set('nestedView', view);
      this.set('isDetailsVisible', true);
      view.set('items', deets);
      view.appendTo(this.$());
    }
  }
});
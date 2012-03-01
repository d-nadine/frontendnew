Radium.FeedItemHeadlineView = Ember.View.extend({
  classNames: ['alert', 'alert-block'],
  // Render the template on the fly based on the type of feed item
  templateName: function() {
    return 'feed_headline_' + this.get('type');
  }.property().cacheable(),
  actionsVisible: false,
  nestedView: null,
  click: function() {
    var type = this.get('filterType').toString();
    var ids = this.get('ids');
    var model = this.get('model');
    
    if (this.get('isDetailsVisible') && this.get('nestedView')) {
      var test = this.get('nestedView');
      test.remove();
      this.set('nestedView', null);
      this.set('isDetailsVisible', false);
    } else {
      var deets = Radium.store.findMany(Radium[model], ids);
      var view = Radium['FeedItem' + model + 'sView'].create();
      this.set('nestedView', view);
      this.set('isDetailsVisible', true);
      view.set('items', deets);
      view.appendTo(this.$().parent());
    }
  }
});
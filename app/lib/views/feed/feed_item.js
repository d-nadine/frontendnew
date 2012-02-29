Radium.FeedItemView = Ember.View.extend({
  items: function() {
    var type = this.get('itemType');
    return Radium.selectedFeedDateController.get(type + 's');
  }.property('itemType'),
  templateName: function() {
    return 'feed_item_' + this.get('itemType') + 's';
  }.property('itemType')
});
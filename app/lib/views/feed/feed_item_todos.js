Radium.FeedItemTodosView = Ember.View.extend({
  // isVisible: function() {
  //   return (this.getPath('parentView.isDetailsVisible')) ? true : false;
  // }.property('parentView.isDetailsVisible'),
  templateName: 'feed_item_todos',
  didInsertElement: function() {
    this.$().hide().slideDown('fast');
  }
});
/**
  Note: Override the init method when creating to load a the required template,
  based on context.
*/
Radium.FeedHeaderView = Ember.View.extend({
  contentBinding: 'parentView.content',
  classNames: 'feed-header span9'.w(),
  attributeBindings: ['title'],
  titleBinding: Ember.Binding.oneWay('content.id'),
  layoutName: 'feed_header_layout',
  isActionsVisibleBinding: 'parentView.isActionsVisible',
  click: function(event) {
    event.stopPropagation();
    this.toggleProperty('isActionsVisible');
  },
  // FIXME: This is a dirty, dirty hack. If Ember Data allows you to 
  // find records from nested objects, destroy me.
  sender: function() {
    if (this.getPath('content.reference.todo.reference.email')) {
      var senderId = this.getPath('content.reference.todo.reference.email.sender.user');
      if (senderId) {
        return Radium.store.find(Radium.User, senderId)
      }
    }
  }.property()
});
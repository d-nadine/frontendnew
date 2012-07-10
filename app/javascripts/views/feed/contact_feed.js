Radium.ContactFeedView = Ember.View.extend(Radium.InfiniteScroller, Radium.FeedBehaviour, {
  templateName: 'general_feed',
  contentBinding: 'Radium.selectedContactController.content',
  controllerBinding: 'Radium.selectedContactController'
});

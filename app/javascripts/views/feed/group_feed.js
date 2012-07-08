Radium.GroupFeedView = Ember.View.extend(Radium.InfiniteScroller, Radium.FeedBehaviour, {
  templateName: 'general_feed',
  contentBinding: 'Radium.groupFeedController.content',
  controllerBinding: 'Radium.groupFeedController',
  didInsertElement: function(){
    $('html,body').scrollTop(10);
  }
});

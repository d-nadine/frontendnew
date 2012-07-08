Radium.DashboardFeedView = Ember.View.extend(Radium.InfiniteScroller, Radium.FeedBehaviour,{
  templateName: 'dashboard_feed',
  contentBinding: 'Radium.activityFeedController.content',
  controllerBinding: 'Radium.activityFeedController',
});

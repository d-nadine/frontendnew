Radium.DashboardFeedView = Ember.View.extend(Radium.InfiniteScroller, {
  templateName: 'dashboard_feed',
  contentBinding: 'Radium.activityFeedController.content',
  controllerBinding: 'Radium.activityFeedController',
  didInsertElement: function(){
    $('html,body').scrollTop(5);
    Radium.get('activityFeedController').set('canScroll', true);
  }
});

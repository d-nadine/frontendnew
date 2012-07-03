Radium.GroupFeedView = Ember.View.create(Radium.InfiniteScroller, {
  templateName: 'general_feed',
  contentBinding: 'Radium.groupFeedController.content',
  controllerBinding: 'Radium.groupFeedController',
  didInsertElement: function(){
    $('html,body').scrollTop(10);
    Radium.get('groupFeedController').set('canScroll', true);
  }
});

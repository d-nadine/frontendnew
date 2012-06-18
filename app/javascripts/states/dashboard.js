Radium.DashboardPage = Ember.State.extend({
  enter: function(manager) {
    var rootView = manager.get('rootView');

    rootView.get('childViews').removeObject(rootView.get('loading'));

    if(!manager.get('dashBoardSideView')){
      manager.set('dashBoardSideView', Ember.View.create({
        templateName: 'dashboard_sidebar'
      }));
    }

    Radium.get('appController').set('sideBarView', manager.get('dashBoardSideView'));

    this._super(manager);
  },

  index: Ember.State.create({ 
    enter: function(manager) {

      if(!manager.get('dashboardFeedView')){
        manager.set('dashboardFeedView', Ember.View.create(Radium.InfiniteScroller, {
          templateName: 'dashboard_feed',
          contentBinding: 'Radium.activityFeedController.content',
          controllerBinding: 'Radium.activityFeedController',
          didInsertElement: function(){
            $('html,body').scrollTop(5);
          },
          addMeeting: function(evt){
            Radium.Pusher.sendDummyPushes();
          }
        }));
      }

      Radium.get('activityFeedController').set('canScroll', true);

      Radium.get('activityFeedController').set('clusterview', manager.get('dashboardFeedView'));
    
      Radium.get('appController').set('feedView', manager.get('dashboardFeedView'));
    }
  })
});

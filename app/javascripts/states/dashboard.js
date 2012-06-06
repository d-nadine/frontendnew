Radium.DashboardPage = Ember.State.extend({
  enter: function(manager) {
    rootView = manager.get('rootView')

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
      
      // if(!manager.get('dashboardFeedView')){
      //   manager.set('dashboardFeedView', Ember.View.create({
      //     templateName: 'dashboard_feed',
      //     contentBinding: 'Radium.activityFeedController.content',
      //     controller: Radium.get('Radium.activityFeedController')
      //   }));
      // }
    
      Radium.get('appController').set('feedView', Radium.getPath('activityFeedController.view'));
    }
  })
});

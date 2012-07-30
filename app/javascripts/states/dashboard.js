Radium.DashboardPage = Radium.State.extend({
  enter: function(manager, transition) {
    this._super(manager, transition);

    if(!manager.get('dashBoardSideView')){
      manager.set('dashBoardSideView', Ember.View.create({
        templateName: 'dashboard_sidebar'
      }));
    }

    Radium.get('appController').set('sideBarView', manager.get('dashBoardSideView'));

    if (!manager.get('notificationsView')) {
      manager.set('notificationsView', Radium.NotificationsView.create({
        controller: Radium.get('notificationsController'),
        contentBinding: 'Radium.notificationsController.content'
      }));
    }

    Radium.get('notificationsController').set('notificationsView', manager.get('notificationsView'));
  },

  index: Radium.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      Radium.get('activityFeedController').set('feedUrl', function(date){
        var id = Radium.getPath('appController.current_user.id');
        var resource = 'users';
        return Radium.get('appController').getFeedUrl(resource, id, date);
      });

      if(!manager.get('dashboardFeedView')){
        manager.set('dashboardFeedView', Radium.DashboardFeedView.create({
          contentBinding: 'Radium.activityFeedController.content',
          controllerBinding: 'Radium.activityFeedController',
          bootstrapBinding: 'Radium.appController'
        }));
      }

      Radium.get('appController').set('feedView', manager.get('dashboardFeedView'));
    }
  })
});

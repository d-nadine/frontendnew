Radium.DashboardPage = Ember.ViewState.extend(Radium.PageStateMixin, {
    
  view: Radium.DashboardView,

  isFormAddView: false,

  index: Ember.State.create({
    firstRun: true,
    loadActivities: function(manager) {
      var user = Radium.usersController.getPath('loggedInUser.id');
      Radium.dashboardFeedController.registerFeeds([
        Radium.feedByKindController
      ]);

      $.ajax({
        url: '/api/users/%@/feed'.fmt(user),
        dataType: 'json',
        contentType: 'application/json',
        type: 'GET',
        success: function(data) {
          Radium.dashboardFeedController.addData(data);
          Ember.run.sync();
          Ember.run.next(function() {
            manager.goToState('ready');
          });
        }
      });
    },
    enter: function(manager) {
      var firstRun = this.get('firstRun');
      if (firstRun) {
        this.loadActivities(manager);
      } else {
        manager.goToState('ready');
      }
    }
  }),

  ready: Ember.State.create({}),

  /**
    ACTIONS
    ------------------------------------
  */
});

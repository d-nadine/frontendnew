function infiniteLoading(action) {
  if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    Radium.App.send(action);
    return false;
  }
}

Radium.DashboardPage = Ember.ViewState.extend(Radium.PageStateMixin, {
    
  view: Radium.DashboardView,

  isFormAddView: false,

  exit: function(manager) {
    $(window).off();
    this._super(manager);
  },

  index: Ember.State.create({
    firstRun: true,
    enter: function(manager) {
      Radium.dashboardFeedController.registerFeeds([
        Radium.feedByKindController,
        Radium.feedByUserController,
        Radium.feedByDayController,
        Radium.feedByActivityController
      ]);

      $(window).on('scroll', function() {
        infiniteLoading('loadFeed');
      });
      
      Ember.run.next(function() {
        manager.send('loadFeed');
      });
    },
    exit: function(manager) {
      this._super(manager);
      $(window).off();
    }
  }),

  ready: Ember.State.create({}),
  loading: Radium.MiniLoader.create({
    enter: function() {
      this._super($(window).off());
    },
    exit: function() {
      $(window).on('scroll', function() {
        infiniteLoading('loadFeed');
      });
      this._super();
    }
  }),

  /**
    ACTIONS
    ------------------------------------
  */
  page: 1,
  loadFeed: function(manager) {
    var self = this,
        user = Radium.usersController.getPath('loggedInUser.id'),
        page = this.get('page');    
    
    Ember.run.next(function() {
      manager.goToState('loading');
    });

    $.ajax({
      url: '/api/users/%@/feed'.fmt(user),
      dataType: 'json',
      contentType: 'application/json',
      type: 'GET',
      data: {page: page},
      success: function(data) {
        Radium.dashboardFeedController.addData(data);
        Radium.dashboardFeedController.refreshAll();
        Ember.run.sync();
        self.incrementProperty('page');
        Ember.run.next(function() {
          manager.goToState('ready');
        });
      }
    });
  }
});

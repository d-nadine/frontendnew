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
        Radium.App.infiniteLoading('loadFeed');
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
        Radium.App.infiniteLoading('loadFeed');
      });
      this._super();
    }
  }),

  /**
    ACTIONS
    ------------------------------------
  */
  page: 0,
  totalPages: 2,
  loadFeed: function(manager) {
    var self = this,
        user = Radium.usersController.getPath('loggedInUser.id'),
        page = this.get('page');

    if (this.get('page') < this.get('totalPages')) {
      Ember.run.next(function() {
        manager.goToState('loading');
      });

      $.ajax({
        url: '/api/users/%@/feed'.fmt(user),
        dataType: 'json',
        contentType: 'application/json',
        type: 'GET',
        data: {page: (page+1), beginDate: Radium.get('today')},
        success: function(data, status, xhr) {
          var totalPages = xhr.getResponseHeader('x-radium-total-pages'),
              currentPage = xhr.getResponseHeader('x-radium-current-page');

          self.setProperties({
            totalPages: parseInt(totalPages),
            page: parseInt(currentPage)
          });

          data.forEach(function(item) {
            item.isNewActivity = false;
          });

          Radium.dashboardFeedController.addData(data);
          Radium.dashboardFeedController.refreshAll();
          Ember.run.sync();

          // if (currentPage < totalPages) {
          //   self.incrementProperty('page');
          // }

          Ember.run.next(function() {
            manager.goToState('ready');
          }); 
        }
      });
    } else {
      $(window).off('scroll');
    }
  }
});

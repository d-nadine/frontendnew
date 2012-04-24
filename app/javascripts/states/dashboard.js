Radium.DashboardPage = Ember.ViewState.extend({
    
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
        Radium.feedByContactController,
        Radium.feedByDateController,
        Radium.feedByActivityController
      ]);

      var todos = Radium.store.find(Radium.Todo, {page:1});

      todos.addObserver('isLoaded', function() {
        var loadedTodos = Radium.store.findAll(Radium.Todo);
        loadedTodos.forEach(function(todo) {
          Radium.todosController.add(todo);
        });
      });

      // if (!manager.get('isEmptyFeed')) {
      //   $(window).on('scroll', function() {
      //     Radium.App.infiniteLoading('loadFeed');
      //   });
      // }
      
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
    exit: function(manager) {
      if (!manager.get('isEmptyFeed')) {
        $(window).on('scroll', function() {
          Radium.App.infiniteLoading('loadFeed');
        });
      }
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
        page = this.get('page'),
        today = Radium.appController.get('today'),
        oneWeekAgo = today.adjust({day: today.get('day') - 7});

    if (this.get('page') < this.get('totalPages')) {
      Ember.run.next(function() {
        manager.goToState('loading');
      });

      var data = {
            url: '/api/users/%@/feed'.fmt(user),
            type: 'GET',
            data: {page: (page+1), before_date: today.toISO8601()}
          },
          request = jQuery.extend(data, CONFIG.ajax);

      $.ajax(request)
        .success(function(data, status, xhr) {
          var totalPages = xhr.getResponseHeader('x-radium-total-pages'),
              currentPage = xhr.getResponseHeader('x-radium-current-page');

          self.setProperties({
            totalPages: parseInt(totalPages),
            page: parseInt(currentPage)
          });

          data.forEach(function(item) {
            item.isNewActivity = false;
            item.isCached = false;
          });

          Radium.dashboardFeedController.addData(data);
          Radium.dashboardFeedController.refreshAll();
          Ember.run.sync();
          // debugger;
          Ember.run.next(function() {
            manager.goToState('ready');
          }); 
        })
        .error(function() {
          $(window).off('scroll');
          manager.set('isEmptyFeed', true);
          manager.goToState('ready');
        });
    } else {
      $(window).off('scroll');
    }
  }
});

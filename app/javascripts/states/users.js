Radium.UsersPage = Ember.State.extend({
  index: Ember.ViewState.extend({
    view: Radium.UsersPageView,
    start: Ember.State.create({
      isFirstRun: true,
      enter: function(manager) {
        if (this.get('isFirstRun')) {
          if (Radium.usersController.get('length') <= 0) {
            Radium.usersController.setProperties({
              content: Radium.store.find(Radium.User, {page: 'all'}),
              totalPages: 1
            });
          }
          
          this.set('isFirstRun', false);
        } else {
          Ember.run.next(function() {
            manager.goToState('ready');
          });
        }
      }
    }),

    ready: Ember.State.create(),

    // Loader for infinite scrolling
    loading: Radium.MiniLoader,
  }),
  
  show: Ember.ViewState.extend({
    view: Radium.UserPageView,
    enter: function(manager) {
      var selectedUser = Radium.selectedUserController,
          userId;

      if (selectedUser.get('user') == null) {
        var user = Radium.store.find(Radium.User, Radium.appController.get('params'));
        selectedUser.set('content', user);
      }
      
      userId = selectedUser.getPath('content.id');

      if (!selectedUser.getPath('content.feed')) {
        var userFeed = Radium.feedController.create({
              content: [],
              dates: {},
              page: 0,
              totalPages: 2
            });
        selectedUser.setPath('content.feed', userFeed);
      }

      this._super(manager);
    },
    exit: function(manager) {
      this._super(manager);
      Radium.selectedUserController.set('content', null);
    },
    ready: Ember.State.create(),
    loading: Radium.MiniLoader
  })
})
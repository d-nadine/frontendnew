/**
  `Radium.App` is the application State Manager.

  The flow goes like this:

  1.  A URL request is intercepted via `Radium.Routes`, sending a `loadPage`
      action.
  2.  `loadPage` determins whether if the user is logged in and if this is 
      the first visit of the sesson. Obviously if the vistor is not logged in,
      we must punt them to the `loggedOut` state.
  3.  If the visitor is logged in, the first step is to load all the account's
      users. All these records are important to start the application with as
      much data as possible on load.
      
*/

Radium.App = Ember.StateManager.create({
  rootElement: '#main',
  enableLogging: true,
  
  loggedOut: Radium.LoggedOutState,

  start: Ember.State.create({
    enter: function() {
      $('#main').empty();
    }
  }),

  // TODO: Add server login logic here.
  authenticate: Ember.ViewState.create({
    view: Radium.LoadingView,
    enter: function(manager) {
      this._super(manager);
      $.when(manager.bootstrapUser())
        .then(
          // Load account data
          function(data) {
            data = data.account;
            Radium.store.load(Radium.Account, data);
            var account = Radium.store.find(Radium.Account, data.id);
            Radium.accountController.set('content', account);
            Radium.appController.setProperties({
              isFirstRun: false,
              isLoggedIn: true
            });

            var users = Radium.store.find(Radium.User, {page: 'all'});

            users.addObserver('isLoaded', function() {
              Radium.usersController.set('content', users);
              manager.send('loginComplete');
            });
          },
          // Error
          function() {
            manager.send('accountLoadFailed');
          }
        )
    },
    loginComplete: function(manager) {
      manager.goToState('loggedIn');
    },
    accountLoadFailed: function(manager) {
      manager.goToState('loggedOut.error');
    }
  }),
  
  loggedIn: Radium.LoggedIn,
  
  error: Ember.State.create({
    enter: function() {
      console.log('error');
    }
  }),
  /**
    ACTIONS
    ------------------------------------
  */
  loadPage: function(manager, context) {
    var app = Radium.appController,
        page = context.page,
        action = context.action || 'index',
        statePath = [page, action].join('.'),
        routeParams = [];

    app.setProperties({
      _statePathCache: statePath,
      currentPage: context.page,
      params: (context.param) ? context.param : null
    });

    if (!Radium.get('_api')) {
      manager.goToState('loggedOut');
      return false;
    }

    if (app.get('isFirstRun')) {
      manager.goToState('authenticate');
    } else {
      manager.goToState(statePath);
    }
    
  },

  bootstrapUser: function() {
    var request = jQuery.extend({url: '/api/account'}, CONFIG.ajax);
    return $.ajax(request);
  }
});

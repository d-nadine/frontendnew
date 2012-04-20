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
  
  loggedOut: Radium.LoggedOutState,

  initialState: function() {
    if (CONFIG.api) {
      return 'authenticate';
    } else {
      return 'loggedOut';
    }
  }.property(),

  // TODO: Add server login logic here.
  authenticate: Ember.ViewState.create({
    view: Radium.LoadingView,
    start: Ember.State.create({
      enter: function(manager) {
        console.log('authenticating...');
        $.when(manager.bootstrapUser())
          .then(
            // Load account data
            function(data) {
              Radium.store.load(Radium.Account, data);
              var account = Radium.store.find(Radium.Account, data.id);
              Radium.accountController.set('content', account);

              Radium.appController.setProperties({
                isFirstRun: false,
                isLoggedIn: true
              });
              manager.goToState('loggedIn');
            },
            // Error
            function() {
              manager.goToState('loggedIn.noData');
            }
          )
      }
    })
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
    
    manager.goToState(statePath);
    
  },

  bootstrapUser: function() {
    var request = jQuery.extend({url: '/api/account'}, CONFIG.ajax);
    return $.ajax(request);
  },

  infiniteLoading: function(action) {
    if ($(window).scrollTop() > $(document).height() - $(window).height() - 300) {
      Radium.App.send(action);
      return false;
    }
  }
});
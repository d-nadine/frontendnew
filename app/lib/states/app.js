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
  
  start: Ember.State.create(),
  // TODO: Add server login logic here.
  authenticate: Ember.ViewState.create({
    view: Radium.LoadingView,
    start: Ember.State.create({
      enter: function(manager) {
        console.log('authenticating...');
        Ember.run.next(function() {
          manager.send('authenticateUser');
        });
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
    var app = Radium.appController;
    app.set('_routeCache', context);
    if (app.get('isFirstRun')) {
      manager.goToState('authenticate');
    } else {
      Radium.appController.set('currentPage', context.page);
      manager.goToState(context.page);
    }
  },

  authenticateUser: function(manager, context) {
    var account = Radium.store.find(Radium.Account, ACCOUNT);
    
    var timer = setTimeout(function() {
      manager.goToState('error');
    }, 5000);

    account.addObserver('isLoaded', function() {
      if (this.get('isLoaded')) {
        clearTimeout(timer);
        Radium.appController.set('isFirstRun', false);
        Radium.appController.set('isLoggedIn', true);
        manager.goToState('loggedIn');
      }
    });
  }
});
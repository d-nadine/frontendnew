/**
  `Radium.App` is the application State Manager.

  The flow goes like this:

  1.  A URL request is intercepted via `Radium.Routes`, sending a `loadSection`
      action.
  2.  `loadSection` determins whether if the user is logged in and if this is 
      the first visit of the sesson. Obviously if the vistor is not logged in,
      we must punt them to the `loggedOut` state.
  3.  If the visitor is logged in, the first step is to load all the account's
      users. All these records are important to start the application with as
      much data as possible on load.
      
*/

Radium.App = Ember.StateManager.create({
  rootElement: '#main',
  // During development set to true
  isLoggedIn: true,
  // Set to false when all the intial data has been loaded
  isFirstRun: true,
  loggedOut: Radium.LoggedOutState,
  
  start: Ember.State.create(),
  // TODO: Add server login logic here.
  authenticate: Ember.ViewState.create({
    view: Radium.LoadingView
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
  loadSection: function(manager, context) {
    if (manager.get('isLoggedIn') && manager.get('isFirstRun') == false) {
      // If this is the first visit in the session, grab some resources first
      Radium.appController.set('currentSection', context);
      manager.goToState(context);
    } else if (manager.get('isLoggedIn')) {
      if (this.get('isFirstRun')) {
        manager.send('authenticateUser', context);
        manager.set('_routeCache', context);
      }
    } else {
      manager.goToState('loggedOut');
    }
  },

  authenticateUser: function(manager, context) {
    console.log('authenticating...', context);
    manager.goToState('authenticate');

    var account = Radium.store.find(Radium.Account, ACCOUNT);
    
    var timer = setTimeout(function() {
      manager.goToState('error');
    }, 5000);

    account.addObserver('isLoaded', function() {
      if (this.get('isLoaded')) {
        clearTimeout(timer);
        manager.set('isFirstRun', false);
        manager.set('isLoggedIn', true);
        manager.goToState('loggedIn');
      }
    });
  }
});
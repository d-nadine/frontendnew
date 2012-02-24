/**
  `Radium.App` is the application State Manager.

  The flow goes like this:

  1.  A URL request is intercepted via `Radium.Routes`, sending a `loadSection`
      action.
  2.  `loadSection` determins whether if the user is logged in and if this is 
      the first visit of the sesson. Obviously if the vistor is not logged in,
      we must punt them to the `loggedOut` state.


  3.  If the visitor is logged in, the first step is to load all the account's
      users. All these records are important for the entire app to run on 
      first load. This is done at `
*/

Radium.App = Ember.StateManager.create({
  rootElement: '#main',
  isLoggedIn: true,
  isFirstRun: true,
  loggedOut: Radium.LoggedOutState,
  
  start: Ember.State.create({
    enter: function() {
      console.log('Booting app');
    }
  }),
  // TODO: Add server login logic here.
  authenticate: Ember.State.create({
    enter: function(manager, transition) {
      console.log('Authenticating.....');
    },
    exit: function(manager) {
      console.log('User authenticated!');
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
  loadSection: function(manager, context) {
    console.log('load %@, and first visit is %@'.fmt(context, this.get('isFirstRun')));

    if (manager.get('isLoggedIn') && manager.get('isFirstRun') == false) {
      // If this is the first visit in the session, grab some resources first
      manager.goToState(context);
      Radium.appController.set('currentSection', context);
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
    account.addObserver('isLoaded', function() {
      if (this.get('isLoaded')) {
        manager.set('isFirstRun', false);
        manager.set('isLoggedIn', true);
        manager.goToState('loggedIn');
      }
    });
  }
});
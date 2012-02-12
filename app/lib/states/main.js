minispade.require('radium/states/dashboard');
minispade.require('radium/states/deals');
minispade.require('radium/states/loggedout');
minispade.require('radium/states/loggedin');


Radium.App = Ember.StateManager.create({
  rootElement: '#main',
  isLoggedIn: NO,
  
  loggedOut: Radium.LoggedOut,
  
  loggingIn: Ember.State.create({
    enter: function(manager, transition) {
      // TODO: Set up form validation logic here.
      console.log('logging in...')
      transition.async();
      transition.resume();
      manager.goToState('loggedIn');
    },
    exit: function(manager, transition) {
      ISLOGGEDIN = true;
      console.log('login successful!');
    }
  }),
  
  loggedIn: Radium.LoggedIn,
  
  error: Ember.State.create({
    enter: function() {
      console.log('error');
    }
  })
});
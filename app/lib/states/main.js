minispade.require('dashboard');
minispade.require('deals');
minispade.require('loggedOut');
minispade.require('loggedin');


Radium.App = Ember.StateManager.create({
  rootElement: '#main',
  isLoggedIn: NO,
  
  loggedOut: Radium.App.LoggedOut,
  
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
  
  loggedIn: Radium.App.LoggedIn,
  
  error: Ember.State.create({
    enter: function() {
      console.log('error');
    }
  })
});
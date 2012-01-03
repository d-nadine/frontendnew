define(function(require) {
  require('ember');
  require('controllers/app');
    
  var loggedOut = require('states/loggedout'),
      loggedIn = require('states/loggedin');
  
  Radium.App = Ember.StateManager.create({
    initialState: 'loggedOut',
    isLoggedIn: NO,
    
    loggedOut: loggedOut,
    
    loggingIn: Ember.State.create({
      enter: function(manager, transition) {
        // TODO: Set up form validation logic here.
        console.log('logging in...')
        transition.async();
        transition.resume();
        manager.goToState('loggedIn');
      },
      exit: function(manager, transition) {
        console.log('login successful!');
      }
    }),
    
    loggedIn: loggedIn,
    
    error: Ember.State.create({
      enter: function() {
        console.log('error');
      }
    }),
    
    // Events
    logIn: function() {
      this.goToState('loggingIn');
    },
    
    loadPage: function() {
      this.goToState('loggedIn.contacts');
    }
  });
  
});